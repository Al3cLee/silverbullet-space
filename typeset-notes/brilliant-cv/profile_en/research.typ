
// Imports
#import "@preview/brilliant-cv:4.0.1": cv-entry, cv-entry-continued, cv-entry-start, cv-section


#cv-section("Research")

#cv-entry(
  title: [`yao-rs` open source contributor],
  society: [Hong Kong University of Science and Technology, Guangzhou],
  date: [2026.6 -- now],
  location: [Remote Collaboration],
  logo: image("assets/logos/yao.pdf"),
  description: list(
    [Re-write the `Julia` quantum computing software package `yao.jl` into the `Rust` package `yao-rs`
      to improve performance and reliability],
  ),
)

#cv-entry(
  title: [Undergraduate Researcher, Ehud Altman group],
  society: [University of California, Berkeley],
  date: [2024.5 -- now],
  location: [Berkeley, CA],
  logo: image("assets/logos/seal_berkeley.svg"),
  description: list(
    [*Obtained* the critical temperature and universality class of the decoherence-induced phase transition in the Kitaev honeycomb model via mean-field theory and frequency-shell renormalization group],
    [*Mapped* the statistical entropy of a mixed state to the entanglement entropy of the Choi-Jamiolkowski (CJ) pure state exactly, thereby *revealed* the generic physical picture of entanglement formation between two CJ layers in decoherence-induced transitions],
    [*Proposed* a fast tensor-network method for topological entanglement entropy based on the CJ isomorphism],
  ),
)
#cv-entry(
  title: [Course Paper, Thermodynamics and Statistical Physics 2],
  society: [Fudan University],
  date: [2024.2 -- 2024.6],
  location: [Shanghai, China],
  logo: image("assets/logos/fudan.png"),
  description: list(
    [*Revealed* that dangerously irrelevant perturbations (DIP) are caused by the breakdown of the linear approximation for the renormalization group flow],
    [*Heuristically justified* the superiority of the Monte Carlo Renormalization Group (MCRG) methods over existing analytic methods when applied to models with DIP's],
    [*Interpreted* the results of MCRG numerics and *confirmed* that DIP's require a new set of critical exponents to describe],
  ),
)
