// Imports
#import "@preview/brilliant-cv:4.0.1": cv-entry, cv-entry-continued, cv-entry-start, cv-section


#cv-section("职业经历")

// #cv-entry-start(
//   society: [XYZ 公司],
//   logo: image("../assets/logos/xyz_corp.png"),
//   location: [旧金山, CA],
// )
//
// #cv-entry-continued(
//   title: [数据科学主管],
//   date: [2020 - 现在],
//   description: list(
//     [领导数据科学家和分析师团队，开发和实施数据驱动的策略，开发预测模型和算法以支持组织内部的决策],
//     [与高级管理团队合作，确定商业机会并推动增长，实施数据治理、质量和安全的最佳实践],
//   ),
//   tags: ("Dataiku", "Snowflake", "SparkSQL"),
// )

#cv-entry(
  title: [固定收益部门实习生],
  society: [兴业证券],
  // logo: image("../assets/logos/abc_company.png"),
  date: [2023.7 - 2023.8],
  location: [上海，中国],
  description: list(
    [阅读并分析2021年8月以来各券商的每月CPI点评报告，总结发现，将商品篮子与其他宏观指标结合分析，并根据具体情况灵活地构建解释框架，是准确地定性预判CPI走势的关键],
    [优化了定量预测CPI的Excel表格，使其自动抓取Wind数据库并进行计算，并且在统计局数据未更新时自动报错],
  ),
)

// #cv-entry(
//   title: [数据分析实习生],
//   society: [PQR 公司],
//   logo: image("../assets/logos/pqr_corp.png"),
//   date: list(
//     [2017年夏季],
//     [2016年夏季],
//   ),
//   location: [芝加哥, IL],
//   description: list(
//     [协助使用 Python 和 Excel 进行数据清洗、处理和分析，参与团队会议并为项目规划和执行做出贡献],
//   ),
// )
