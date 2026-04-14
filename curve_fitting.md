---
finished: false
---

#physics/experiment
#math/probabilities
#computer-science/julia

# Curve Fitting and the Goodness of Fit

**Motivation.** We have performed an experiment and collected data points $(x_i, y_i)$ with associated uncertainties $\sigma_i$. After choosing a model $y = f(x; \mathbf{u})$ with parameters $\mathbf{u}$ and fitting it to the data, a natural question arises: _how do we know the goodness of our fit?_ Two diagnostics are commonly used: the mean relative error and the reduced chi-squared. But even after a fit passes both tests, the fitted parameters $\mathbf{u}$ are typically reported as bare numbers — yet they are themselves uncertain. Treating them as such leads to the question of how to propagate their uncertainties, and in particular their correlations, into downstream predictions.

**Discussion.** The simplest and most intuitive diagnostic is the **mean relative error** (MRE), defined as

$$
\text{MRE} = \frac{1}{N}\sum_{i=1}^N \frac{|y_i - f(x_i; \mathbf{u})|}{|y_i|} \times 100\%.
$$

It is easy to compute and interpret: if the MRE is 2%, the model's predictions differ from data by 2% on average. But the MRE has a limitation — it ignores the uncertainties $\sigma_i$. A 2% error is excellent when $\sigma_i / y_i = 10\%$, but unacceptable when $\sigma_i / y_i = 0.1\%$.

This is where the **reduced chi-squared** becomes essential. Given fitted parameters $\mathbf{u}$ obtained by weighted least squares (minimizing $\sum_i (y_i - f(x_i;\mathbf{u}))^2 / \sigma_i^2$), we define

$$
\chi^2_\nu = \frac{1}{N - p}\sum_{i=1}^N \frac{(y_i - f(x_i;\mathbf{u}))^2}{\sigma_i^2}
$$

where $N$ is the number of data points and $p$ is the number of fit parameters. The interpretation is:

- $\chi^2_\nu \approx 1$: the fit is consistent with the stated uncertainties.
- $\chi^2_\nu \gg 1$: the model is insufficient or the uncertainties are underestimated.
- $\chi^2_\nu \ll 1$: the uncertainties are overestimated.

In Julia, with [[Measurements.jl]] and [[CurevFitting.jl]]:

```julia
y_pred = predict(sol)
dof = length(y_nom) - length(sol.u)
chi_sq = sum(((y_nom .- y_pred) ./ y_sigma).^2)
reduced_chi_sq = chi_sq / dof
```

To perform the weighted fit itself, pass `sigma` (the standard deviations) to CurveFit.jl. For linear fits it is a keyword argument; for nonlinear fits it is a positional argument:

```julia
# Linear weighted fit
prob = CurveFitProblem(x, y_nom; sigma=y_sigma)

# Nonlinear weighted fit — sigma is positional!
prob = NonlinearCurveFitProblem(fn, u0, x, y_nom, y_sigma)
```

**Result.** For assessing goodness of fit when uncertainties are available, the reduced chi-squared $\chi^2_\nu$ supersedes the mean relative error because it incorporates the weight of evidence carried by each data point. The mean relative error (MRE) remains a useful supplementary metric that is robust to mis-estimated uncertainties, since it does not depend on $\sigma_i$ at all. Together, they give a complete picture: $\chi^2_\nu$ tells you whether the model is consistent with the data given their error bars, while MRE tells you the typical size of residuals in percentage terms.

**Remark.** Both diagnostics treat the fitted parameters $\mathbf{u}$ as fixed nominal values — they say nothing about the uncertainty _on the parameters themselves_. A good $\chi^2_\nu$ tells you the model is adequate, but if you then use $\mathbf{u}$ to predict $y$ at a new $x$, you have no error bar on the prediction.

---

**Motivation.** The fitted parameters $\mathbf{u}$ are themselves subject to uncertainty. In a linear fit $y = ax + b$, the slope $a$ and intercept $b$ each have a standard deviation, and crucially, they are _correlated_. If we treat them as independent, we underestimate or overestimate the uncertainty in predictions. How do we promote $\mathbf{u}$ from a plain vector of numbers into error-propagating objects that carry both uncertainty and correlation?

**Discussion.** When we solve the least-squares problem, CurveFit.jl (via [[statsapi]]) provides not just the point estimates `sol.u` but also `vcov(sol)`, the estimated covariance matrix of the parameters. The diagonal entries give the variances $\text{Var}(u_i)$, and the off-diagonal entries give the covariances $\text{Cov}(u_i, u_j)$. For a linear fit $y = ax + b$, there is typically a strong negative correlation between $a$ and $b$: if the slope is slightly too steep, the intercept compensates by shifting down.

If we were to wrap each parameter independently as `sol.u[i] ± sqrt(vcov[i,i])`, we would lose this correlation. Two `Measurement` objects created this way would be _independent_, so downstream arithmetic like `prediction = a * x + b` would compute the propagated uncertainty as if $a$ and $b$ varied independently — overestimating the uncertainty when they are negatively correlated.

The function `Measurements.correlated_values` solves this. It takes the nominal values and the covariance matrix and produces `Measurement` objects that are _linked_: their shared dependency structure is tracked internally, so that when they appear together in an expression, the covariance is correctly propagated.

To understand how the linking works, consider the source of the three-argument form `correlated_values(nominal_values, standard_deviations, correlation_matrix)`. The two-argument form we call — `correlated_values(nominals, cov_mat)` — computes the standard deviations as `sqrt.(diag(cov_mat))` and the correlation matrix by normalizing the covariance, then delegates to the three-argument form. Here is the three-argument version in full:

```julia
function correlated_values(
    nominal_values::AbstractVector{<:Real},
    standard_deviations::AbstractVector{<:Real},
    correlation_matrix::AbstractMatrix{<:Real},
)
    eig = eigen(correlation_matrix)::Eigen{Float64}

    variances = eig.values
    # Inverse is equal to transpose for unitary matrices
    transform = eig.vectors'
    # Avoid numerical errors
    variances[findall(x -> x < eps(1.0), variances)] .= 0
    variables = map(variances) do variance
        measurement(0, sqrt(variance))
    end

    transform .*= standard_deviations'
    transform_columns = [view(transform,:,i) for i in axes(transform, 2)]

    values_funcs = [Measurements.result(n, t, variables)
                    for (n, t) in zip(nominal_values, transform_columns)]

    return values_funcs
end
```

The key mathematical idea is a _change of basis into uncorrelated (independent) variables_. Suppose we have correlated parameters with correlation matrix $\mathbf{C}$. Since $\mathbf{C}$ is real and symmetric, its eigendecomposition gives

$$
\mathbf{C} = \mathbf{V} \boldsymbol{\Lambda} \mathbf{V}^\top
$$

where $\mathbf{V}$ is orthogonal ($\mathbf{V}^\top = \mathbf{V}^{-1}$) and $\boldsymbol{\Lambda}$ is diagonal with the eigenvalues. The line `eig = eigen(correlation_matrix)` computes exactly this decomposition.

The code then constructs a set of independent `Measurement` objects — one per eigenvalue — via `measurement(0, sqrt(variance))`. These are zero-mean independent random variables $Z_k$ with variances equal to the eigenvalues of $\mathbf{C}$. Because they are created as _separate_ calls to `measurement`, they are truly independent in the [[measurements_jl]] sense: no two share the same internal tag.

The next step is the heart of the algorithm. Each original parameter $u_i$ is reconstructed as a linear combination of these independent variables:

$$
u_i = \hat{u}_i + \sigma_i \sum_k V_{ki} \, Z_k
$$

where $\hat{u}_i$ is the nominal value and $\sigma_i$ is the standard deviation. The matrix `transform = eig.vectors' * standard_deviations'` encodes the coefficients $\sigma_i V_{ki}$; its columns are the derivatives of each $u_i$ with respect to the $Z_k$. The line `transform .*= standard_deviations'` scales each row $\mathbf{V}^\top_{k,:}$ by the standard deviations, yielding exactly these coefficients. Finally, `Measurements.result(nominal_value, derivatives, variables)` builds each `Measurement` object as `nominal_value + sum(derivatives .* variables)`, which is precisely the linear combination above.

Why does this recover the correct correlations? By construction, each $Z_k$ is independent. The variance of $u_i$ is

$$
\text{Var}(u_i) = \sigma_i^2 \sum_k V_{ki}^2 \lambda_k = \sigma_i^2 (\mathbf{V} \boldsymbol{\Lambda} \mathbf{V}^\top)_{ii} = \sigma_i^2 \cdot 1 = \sigma_i^2
$$

since the diagonal of the correlation matrix is all ones. And the covariance between $u_i$ and $u_j$ is

$$
\text{Cov}(u_i, u_j) = \sigma_i \sigma_j \sum_k V_{ki} V_{kj} \lambda_k = \sigma_i \sigma_j \, C_{ij}
$$

which is exactly the $(i,j)$ entry of the original covariance matrix. All correlations are faithfully reproduced because both $u_i$ and $u_j$ depend on the _same_ set of independent $Z_k$'s, and the linear error propagation in [[measurements_jl]] tracks these shared dependencies through the derivative dictionary stored inside each `Measurement`.

```julia
using Measurements, CurveFit

# ... after fitting ...
cov_mat = vcov(sol)
params = Measurements.correlated_values(collect(sol.u), cov_mat)

# params[1] and params[2] are now correlated Measurement objects
y_at_5 = params[1] * 5.0 + params[2]   # uncertainty propagated with correlation
```

The difference is dramatic in practice: for a linear fit with strongly anti-correlated slope and intercept, the independent approximation can overestimate the prediction uncertainty by factors of 2–3, while `correlated_values` gives the correct result.

For nonlinear models, the same pattern holds — pass the `Measurement` array as the parameter vector directly into the model function:

```julia
fn(u, x) = @. u[1] * exp(-u[2] * x)
y_pred = fn(params, x_val)
```

**Result.** Fitted parameters should be treated as uncertain, correlated observables, not as bare numbers. The function `Measurements.correlated_values(nominals, vcov)` promotes a vector of nominal values and its covariance matrix into an array of `Measurement` objects that propagate both uncertainty and correlation through all downstream arithmetic. This is the correct way to quote fit results and make predictions with error bars.

**Remark.** A common alternative is to quote confidence intervals from `confint(sol)`, but these only give marginal intervals for each parameter individually — they cannot be used for prediction because they discard correlations. The covariance-matrix approach via `correlated_values` strictly generalizes the confidence-interval approach. The trade-off is that `correlated_values` uses linear error propagation (first-order Taylor expansion of the model about the nominal values), which is accurate when uncertainties are small relative to curvature; for strongly nonlinear models with large uncertainties, a Monte Carlo approach may be more appropriate.