#import "preamble.typ": *
#show: template-touying
// #show: template-doc

#title-slide()

= Introduction

In the Franck-Hertz experiment with argon gas, the collector current $I$ vs. acceleration voltage $U_a$ curve exhibits periodic peaks and valleys. A notable observation is that as $U_a$ increases, the peaks not only grow in amplitude but also become sharper: the energy distribution of arriving electrons becomes more concentrated.

The (naive) condition for detection is:
$
  exists n "s.t." quad n Delta E < E - e U_p < (n + 1) Delta E .
$<eqn:binning>

#figure(
  image("SCAN001.pdf", width: 60%),
  caption: [Experimental Franck-Hertz curve (SCAN001) showing periodic peaks and valleys in collector current $I_P$ vs acceleration voltage $U_a$.],
) <fig-scan001>

// #motivation[
//   Assuming $N(E)$ remains the same shape as $E$ is shifted up by increasing $U_a$, how do we explain a narrowing peak on the $I(U_a)$ graph?
//   In fact, the absolute sharpening of the $I(U_a)$ peaks must solely arise from an *absolute* narrowing of the $N(E)$ distribution itself. If $N(E)$ simply shifted to higher energies with a constant absolute spread ($sigma_E = "const"$), the $I(U_a)$ peaks, which are essentially integrals over $N(E)$, would maintain identical voltage widths.
//   We must thus identify the physical processes during acceleration that genuinely concentrate the energy distribution in absolute terms.
// ]

= Mechanisms for Peak Sharpening

== The "Poisson Broadening" Effect (A False Lead)

// It is tempting to attribute the sharpening to the statistical "averaging" of multiple collisions. One might model the electron's passage through the tube as a Poisson process. With an expected number of collisions $overline(n)$, the fractional variance $sigma_n / overline(n) = 1 / sqrt(overline(n))$ decreases as $U_a$ (and therefore $overline(n)$) grows.
//
// However, this "multiple-collision averaging" does *not* explain absolute sharpening. It actually predicts the opposite. While the fractional variance decreases, the *absolute* variance in the collision count is $sigma_n = sqrt(overline(n))$.
Because each inelastic collision deducts a fixed quantum $Delta E$, the absolute energy spread contributed purely by the variance in $n$ is:
$ sigma_E approx Delta E sqrt(overline(n)) . $
As $U_a$ increases, $overline(n)$ increases, meaning this Poisson process actually *broadens* the energy distribution $N(E)$ and the $I(U_a)$ peaks.

// Therefore, the true cause of the sharpening must overcome this Poisson broadening effect. The mechanism lies in the energy dependence of the excitation cross section.

== Energy-Dependent Excitation Cross Section and Threshold Filtering

The true driving force behind the absolute narrowing of $N(E)$ is the interplay between the accelerating electric field and the highly non-linear inelastic cross section $sigma_"exc"(E)$ of argon.

// It is tempting to visualize a "static" picture where a pre-existing, broad thermal energy distribution $N(E)$ simply drifts up in energy and gets "combed" or filtered by the $Delta E$ spacing. This is incorrect.
// Instead, we must adopt a *dynamic* picture: the cross-section threshold acts as an active, hard reset during the acceleration itself.

The inelastic cross section $sigma_"exc"(E)$ has a sharp threshold at $E = Delta E approx 11.6 "eV"$ and rises extremely steeply. Consider the spatial dimension $z$ along the tube, with a uniform electric field $cal(E)$. An electron's kinetic energy is $ E(z) = e cal(E) z. $ The probability of undergoing an inelastic collision within a distance $d z$ is $ n_"Ar" sigma_"exc"(E(z)) d z $.
---
Because $sigma_"exc"(E)$ is near zero for $E < Delta E$, an electron travels freely up to the threshold energy $Delta E$. Let $S(z)$ be the probability that an electron survives up to position $z$ *without* undergoing an inelastic collision:
$ S(z) = exp(-integral_0^z n_"Ar" sigma_"exc"(e cal(E) z') d z') . $<eqn:survival>

The exponential form of $S(z)$ arises directly from modeling the collisions as a non-homogeneous Poisson process.
// In any infinitesimal interval $d z'$, the probability of a collision is $lambda(z') d z'$, where the rate is $lambda(z') = n_"Ar" sigma_"exc"(e cal(E) z')$. The probability of observing exactly zero events (i.e., surviving) over the macroscopic path from $0$ to $z$ is exactly given by the Poisson probability $P(k=0) = exp(-Lambda)$, where the integrated rate is $Lambda = integral_0^z lambda(z') d z'$.

// Because of the steepness of $sigma_"exc"$, the integrated rate $Lambda$ shoots up and $S(z)$ plummets rapidly just past the threshold coordinate $z_"th" = (Delta E) / (e cal(E))$.
This means escaping the "first comb" (the first threshold crossing) without scattering is exponentially rare. The probability density $p(z) d z = S(z) n_"Ar" sigma_"exc" d z$ of colliding is heavily concentrated in a very narrow spatial window just beyond $z_"th"$.
---
When the electron does collide, it loses exactly $Delta E$. Its residual energy immediately after the collision is its small "overshoot" energy:
$ E_"after" = E_"before" - Delta E = e cal(E) z - Delta E equiv delta E . $
Since the collision is forced to occur almost immediately after crossing the threshold, this residual overshoot $delta E$ is tightly bounded to near-zero.
---
=== The Markov Renewal of Multiple Scatters

How does this single-scatter survival formula help us understand multiple scatters and the overall $N(E)$?

Because the electron's kinetic energy plummets to the tiny overshoot $delta E approx 0$ after a collision, the electron effectively "forgets" its past. The acceleration process starts anew.
The sequence of multiple collisions is a *Markov renewal process*. The electron accelerates again, and the survival formula $S(z)$ dictates the statistics of the *next* collision independently.

Crucially, this means the residual energy distribution after the $n$-th collision does *not* accumulate the variance of the previous $n-1$ collisions! The energy spread immediately after the $n$-th scatter is solely determined by the overshoot $delta E_n$ of that *last* specific cycle, which is strictly governed by the steep drop-off of $S(z)$.
---
#result("Dynamics Threshold Reset")[
  The sharp excitation threshold actively truncates the acceleration. Instead of a single broad distribution being statically filtered, the threshold acts as a repeated "memory wipe". By resetting the energy to a tightly bounded overshoot $delta E$ at every collision, it completely suppresses the $sqrt(n)$ variance accumulation (the Poisson broadening), explaining why the absolute energy spread remains narrow even after many collisions.
]
---
=== Cascading Filtration and Absolute Sharpening

While the Markov reset explains why the spread is bounded, why do the $I(U_a)$ peaks become progressively *sharper* (narrower) at higher $U_a$ (i.e., higher collision counts $n$)?

💡 Wave picture!

$
  "phase" ~ exp ("i" delta E)
$

#figure(
  image("U_P-dI.pdf", width: 65%),
  caption: [Joined retarding-potential data (rounds 5-4-1-2-3) showing the derivative signal $d I$ vs retarding potential $U_P$.],
) <fig-up-di>

#figure(
  image("U_offset-dI.pdf", width: 65%),
  caption: [Derivative signal $d I$ vs offset voltage $U_"offset"$, illustrating the resonant structure of the collector current.],
) <fig-uoffset-di>

// This progressive sharpening is due to a cascading "distillation" or selection effect. The initial electron beam emitted from the cathode possesses a broad thermal energy spread (approx $0.1 "eV"$). During the first inelastic collision, this initial thermal variance is completely erased and replaced by the variance of the overshoot $delta E_1$, which is dictated by the steepness of the cross section. Because the cross section acts as a strong active filter, the overshoot variance is generally smaller than the initial thermal spread, causing the beam to be actively "cooled."
//
// Furthermore, as $U_a$ increases, electrons must survive *multiple* threshold crossings. Any electron that suffers an anomalous scatter (e.g., an unusually large overshoot, or an elastic deflection that alters its longitudinal velocity) falls slightly out of phase with the main synchronous "packet." Because the threshold reset only tightly bounds the energy of electrons that continuously scatter exactly near $Delta E$, the multiple collisions act as a cascading series of filters. After many collisions, the "surviving" synchronous electrons that make up the macroscopic peak are only those that have perfectly conformed to the threshold rhythm. The anomalous electrons are stripped from the main packet and relegated to the flat background current, leaving a highly concentrated, absolutely sharpened energy distribution $N(E)$ for the peak.
//
// This separation can also be viewed through the wave picture of electrons. An electron that retains a large residual $delta E$ after a collision accumulates a large anomalous phase proportional to $exp("i" c delta E)$ (where $c$ depends on the kinematics). As it propagates through multiple scattering cycles, this phase error accumulates, causing the electron to fall completely out-of-phase with the rest of the synchronous wave packet. The macroscopic current peak is formed only by the highly coherent sub-population that maintains minimal $delta E$, while the out-of-phase electrons merge into the incoherent background. This leaves the coherent peak extremely sharp in absolute terms.

// == Reduced Influence of Elastic Scattering at Higher Energies
//
// Elastic (momentum-changing) collisions randomize electron directions, effectively increasing the path length required to advance a given distance along the tube, which broadens the energy distribution. However, for argon at the relevant energies, the elastic cross section $sigma_"el"(E)$ _decreases_ with increasing electron energy (Ramsauer–Townsend effect in reverse above the minimum), while $sigma_"exc"(E)$ increases.
//
// At higher $U_a$, the ratio $sigma_"exc" / sigma_"el"$ increases. This means the "useful" energy-loss channel (sharp, discrete $Delta E$ removal) becomes dominant over the "blurring" channel (elastic deflection).
//
// #result[
//   As $U_a$ increases, the relative dominance of inelastic scattering reduces angular blurring. This allows the electron beam to maintain better phase coherence along the accelerating field.
// ]

= Summary

#figure(
  table(
    columns: (auto, 1fr),
    [Mechanism], [Effect on $N(E)$],
    [Poisson Statistics], [Naturally *broadens* absolute spread ($sigma_E tilde sqrt(overline(n))$) at higher $U_a$.],
    [Excitation Threshold],
    [Sharp cross-section filters energy, continually re-synchronizing spatial position and restricting residual energy spread.],

    [Cross-section Ratio],
    [$sigma_"exc" slash sigma_"el"$ increases with $E$, \ reducing directional blurring at higher energies.],
  ),
  caption: [Summary of mechanisms governing the energy spread $N(E)$.],
) <tab-summary>

// #remark[
//   The absolute sharpening of Franck-Hertz peaks at higher acceleration voltages is a direct manifestation of the steep, threshold-like nature of the atomic excitation cross section. This mechanism acts as a continuous "focusing" filter that tightly bounds the electrons' kinetic energy variations, successfully combating the statistical broadening that would otherwise occur from multiple random collision events.
// ]
//
#[
  #counter(heading).update(0)
  #set heading(numbering: "A. ", supplement: [Appendix])
  #set math.equation(numbering: (..nums) => {
    let section = counter(heading).get().first()
    numbering("(A.1)", section, ..nums)
  })
  = Homogeneous Poisson Processes

  A homogeneous Poisson process is a counting process $N(t)$ that models the number of events occurring up to time $t$ (or position $z$), where the events occur at a constant average rate $lambda$.

  Let $P_n(t)$ be the probability that exactly $n$ events have occurred in the interval $[0, t]$. The process satisfies two key properties for an infinitesimal interval $Delta t$:
  1. The probability of exactly one event in $Delta t$ is $lambda Delta t + o(Delta t)$.
  2. The probability of more than one event in $Delta t$ is $o(Delta t)$.

  From these properties, we can derive the differential equations governing $P_n(t)$. For $n = 0$, the probability of zero events up to time $t + Delta t$ is the probability of zero events up to time $t$ multiplied by the probability of zero events in the next $Delta t$:
  $ P_0(t + Delta t) = P_0(t) (1 - lambda Delta t) + o(Delta t) . $
  Rearranging and taking the limit as $Delta t arrow.r 0$ yields the differential equation:
  $ (d P_0(t)) / (d t) = -lambda P_0(t) . $
  With the initial condition $P_0(0) = 1$, the solution is:
  $ P_0(t) = exp(-lambda t) . $

  For $n > 0$, exactly $n$ events occur by time $t + Delta t$ either if $n$ events occurred by $t$ and none in $Delta t$, or $n-1$ events occurred by $t$ and exactly one occurred in $Delta t$:
  $ P_n(t + Delta t) = P_n(t) (1 - lambda Delta t) + P_(n-1)(t) (lambda Delta t) + o(Delta t) . $
  This leads to the differential equation:
  $ (d P_n(t)) / (d t) = -lambda P_n(t) + lambda P_(n-1)(t) . $
  Using an integrating factor $exp(lambda t)$ and proceeding by induction, the general solution for the probability of $n$ events is the standard Poisson distribution:
  $ P_n(t) = ((lambda t)^n) / (n!) exp(-lambda t) . $

  = Inhomogeneous Poisson Processes

  An inhomogeneous (or non-homogeneous) Poisson process relaxes the assumption of a constant rate. Instead, the rate of events $lambda(t)$ is allowed to vary as a function of time (or position $z$).

  We define the integrated rate function (or cumulative hazard function) $Lambda(t)$ as the expected number of events up to time $t$:
  $ Lambda(t) = integral_0^t lambda(tau) d tau . $

  The derivation of the probability $P_n(t)$ proceeds similarly to the homogeneous case, but with the rate $lambda$ replaced by the instantaneous rate $lambda(t)$. The differential equation for zero events becomes:
  $ (d P_0(t)) / (d t) = -lambda(t) P_0(t) . $
  Integrating this differential equation from $0$ to $t$ with the condition $P_0(0) = 1$ gives the survival probability:
  $ P_0(t) = exp(-integral_0^t lambda(tau) d tau) = exp(-Lambda(t)) . $
  This is exactly the survival formula @eqn:survival used to model the probability of an electron reaching position $z$ without an inelastic collision, where $lambda(z') = n_"Ar" sigma_"exc"(e cal(E) z')$.

  For $n > 0$, the corresponding differential equation is:
  $ (d P_n(t)) / (d t) = -lambda(t) P_n(t) + lambda(t) P_(n-1)(t) . $
  By defining $Q_n(t) = P_n(t) exp(Lambda(t))$, the equation simplifies to $(d Q_n(t)) / (d t) = lambda(t) Q_(n-1)(t)$. Solving by induction yields the probability of $n$ events for an inhomogeneous Poisson process:
  $ P_n(t) = ((Lambda(t))^n) / (n!) exp(-Lambda(t)) . $
]
