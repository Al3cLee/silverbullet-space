
// Imports
#import "@preview/brilliant-cv:4.0.1": cv-entry, cv-entry-continued, cv-entry-start, cv-section


#cv-section("学术研究")

#cv-entry(
  title: [`yao-rs`开源贡献者，刘金国课题组],
  society: [香港科技大学广州校区],
  date: [2026.6 至今],
  location: [远程合作],
  logo: image("assets/logos/yao.pdf"),
  description: list(
    [将基于`Julia`语言的量子计算软件包重写为基于`Rust`的软件包`yao-rs`，优化其性能],
  ),
)

#cv-entry(
  title: [科研助理, Ehud Altman课题组],
  society: [加州大学伯克利分校],
  date: [2024.5 至今],
  location: [伯克利，CA],
  logo: image("assets/logos/seal_berkeley.svg"),
  description: list(
    [基于平均场理论和时间维度的重整化，得到了Kitaev蜂窝模型的退相干相变的临界温度和普适类],
    [利用量子信息方法，证明了混态的统计熵与Choi-Jamiolkowski (CJ) 纯态的纠缠熵的严格等式，揭示出退相干相变的物理图像是CJ纯态的纠缠从层内转移到两层之间],
    [基于CJ纯态，针对拓扑纠缠熵和退相干相变，提出了 $cal(O)\(sqrt(N)\)$ 加速的张量网络算法],
  ),
)
#cv-entry(
  title: [课程论文，《热力学与统计物理2》],
  society: [复旦大学],
  date: [2024.5 至今],
  location: [上海，中国],
  logo: image("assets/logos/fudan.png"),
  description: list(
    [揭示了Dangerously Irrelevant Perturbations (DIP) 出现是因为重整化群流的线性近似在相变临界点附近不成立],
    [证明了基于Monte Carlo有限尺寸模拟的数值重整化方案在DIP问题中的效用],
    [针对Monte Carlo数值重整化的结果给出理论解释，确证了DIP需要在临界点附近采用一组新的临界指数来描述],
  ),
)
