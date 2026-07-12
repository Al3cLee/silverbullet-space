// Imports
#import "@preview/brilliant-cv:4.0.1": cv-entry, cv-section


#cv-section("Projects and Societies")

#cv-entry(
  title: [Partner Content Creator],
  society: [#link("https://pattern.swarma.org/user/79370")[Swarma Club]],
  date: [2026.3 -- now],
  logo: image("assets/logos/swarma.webp"),
  location: [],
  description: list(
    [Track the developments of interdisciplinary research of quantum technology and complex systems,
      and write blog posts or journal article explainers,
      such as
      #link("https://mp.weixin.qq.com/s/bB4jRFqDuHGFIs26aXU_XQ")[_Q-day Crisis of Cryptocurrencies_], and
      #link(
        "https://mp.weixin.qq.com/s/zhFrc9zJ475EtZv2JxlITw",
      )[_Quantum Reservoir Computation at the Edge of Chaos_]],
  ),
)
#cv-entry(
  title: [Active Member],
  society: [#link("https://qcb.studentorg.berkeley.edu")[#text(
    weight: "regular",
  )[Quantum Computing Society of Berkeley]]],
  date: [2024.2 - 2024.7],
  location: [Berkeley, CA],
  logo: image("assets/logos/seal_berkeley.svg"),
  description: list(
    [Tracked the developments of quantum computing, and present in the journal club],
    [Gave a scientific talk on the potential applications of quantum computing to statistical physics],
  ),
)
