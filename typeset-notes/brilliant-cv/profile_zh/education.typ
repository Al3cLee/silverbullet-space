// Imports
#import "@preview/brilliant-cv:4.0.1": cv-entry, cv-section, h-bar


#cv-section("教育经历")


#cv-entry(
  title: [访问学生],
  society: [加州大学伯克利分校],
  date: [2024.1 - 2024.5],
  location: [伯克利，CA],
  logo: image("assets/logos/seal_berkeley.svg"),
  description: list(
    [课程论文: Optical Tests of Bell's Inequality (满分)],
    [课程: GPA 3.97/4 #h-bar() 量子力学2（A+） #h-bar() 量子计算导论（A） #h-bar() 非线性与量子光学（A-）],
  ),
)
#cv-entry(
  title: [物理学，学士],
  society: [复旦大学],
  date: [2021.9 - 2026.6],
  location: [上海，中国],
  logo: image("assets/logos/fudan.png"),
  description: list(
    [课程: GPA 3.44/4 #h-bar() 热力学与统计物理1（荣誉课，A） #h-bar() 热力学与统计物理2（A, top 5\%） #h-bar() 计算物理模拟实验（A-）],
  ),
)
