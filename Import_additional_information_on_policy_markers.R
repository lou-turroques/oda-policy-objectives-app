################################################################################
#######    INPORT ADDITIONAL INFO - R SCRIPT FOR R SHINY APP     ######
################################################################################

script_name <- "4.Import_additional_information_on_policy_markers.R"
print(script_name)



# Policy markers names ----------------------------------------------------


policy_markers_names <- c(
  "gender" = "Gender equality",
  "environment" = "Environment",
  "biodiversity" = "Biodiversity",
  "climate_mitigation" = "Climate mitigation",
  "climate_adaptation" = "Climate adaptation",
  "desertification" = "Desertification",
  "rmnch" = "RMNCH",
  "dig" = "DIG",
  "drr" = "DRR",
  "nutrition" = "Nutrition",
  "disability" = "Disability"
)

policy_markers_lowercase_names <- c(
  "gender" = "gender equality",
  "environment" = "environment",
  "biodiversity" = "biodiversity",
  "climate_mitigation" = "climate mitigation",
  "climate_adaptation" = "climate adaptation",
  "desertification" = "desertification",
  "rmnch" = "RMNCH",
  "dig" = "DIG",
  "drr" = "DRR",
  "nutrition" = "nutrition",
  "disability" = "disability"
)





# Markers Methodology used for the policy objective:---------------------------------------------------


marker_texts <- list(
  gender = "
    <br><b>General reporting information</b>
    <br>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Hungary</b>, as the donor did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Estonia, Poland and the Slovak Republic</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2017</b> (on 2016 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2019</b> (on 2018 flows).
    <br>
    <br><b>Methodology used for the policy objective: Gender Equality and Women's Empowerment (GEWE)</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>gender equality-focused</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It is intended to advance gender equality and women s empowerment or reduce discrimination and inequalities based on sex.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>Gender equality is <b>explicitly promoted</b> in activity documentation through specific measures which:
    <br> &nbsp; &nbsp; - a) Reduce social, economic or political power inequalities between women and men, girls and boys, ensure that women benefit equally with men from the activity, or compensate for past discrimination; or
    <br> &nbsp; &nbsp; - b) Develop or strengthen gender equality or anti-discrimination policies, legislation or institutions.
    <br><i>This approach requires analysing gender inequalities either separately or as an integral part of agencies  standard procedures.</i>
    <br>
    <br><u>Examples of typical activities</u>
    <br><i><u>Examples of activities that could be marked as principal objective:</u></i>
    <br> &nbsp; &nbsp; - legal literacy for women and girls;
    <br> &nbsp; &nbsp; - male networks against gender violence;
    <br> &nbsp; &nbsp; - a social safety net project which focuses specifically on assisting women and girls as a particularly disadvantaged group in a society;
    <br> &nbsp; &nbsp; - capacity building of Ministries of Finance and Planning to incorporate gender equality objectives in national poverty reduction or comparable strategies.
    <br><i>Such activities can target women specifically, men specifically or both women and men.</i>
    <br><i><u>Examples of activities that could be marked as significant objective:</u></i>
    <br> &nbsp; &nbsp; - activity which has as its principal objective to provide drinking water to a district or community while at the same time ensuring that women and girls have safe and easy access to the facilities;
    <br> &nbsp; &nbsp; - a social safety net project which focuses on the community as a whole and ensures that women and girls benefit equally with men and boys.
    <br>
    <br><i><b>Important note</b>: Support to Women's rights organisations and movements, and government institutions <b>(CRS sector code 15170)</b> and to Ending violence against women and girls <b>(CRS sector code 15180)</b> scores, by definition, principal objective.</i>
    <br>",
  rmnch = "
    <br><b>General reporting information</b>
    <br>
    <br>This policy marker was first introduced in 2014 on 2013 flows.
    <br> &nbsp; &nbsp; - Data are not shown for <b>France and Latvia</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>France, Germany, Lithuania and New Zealand</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Finland and the EU</b> started to report on this marker in <b>2016</b> (on 2015 flows).
    <br> &nbsp; &nbsp; - <b>Switzerland and Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary and the United Kingdom</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Slovenia</b> started to report on this marker in <b>2022</b> (on 2021 flows).
    <br>
    <br><b>Methodology used for the policy objective: Reproductive, Maternal, Newborn and Child Health (RMNCH)</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as RMNCH if:
    <br> &nbsp; &nbsp; - It contributes to achieving improved maternal, newborn and child health based on the  continuum of care  concept: The  Continuum of Care  for reproductive, maternal, newborn and child health (RMNCH) implies a life-cycle approach and includes integrated service delivery for women and children from reproductive health to pre-pregnancy, delivery, the immediate postnatal period, and childhood. Such care is provided by families, households and communities as well as through inclusive outpatient services, clinics and other health facilities on district and national level. The Continuum of Care recognises that reproductive choice and safe childbirth are critical to the health of both the woman and the newborn child - and that a healthy start in life is an essential step towards a sound childhood and a productive life.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>The activity contributes to any one of the following:
    <br> &nbsp; &nbsp; - a) Improved access for women and children to a comprehensive, integrated package of essential health interventions and services along the continuum of care;
    <br> &nbsp; &nbsp; - b) Strengthening health systems in order to improve access to and deliver integrated high-quality RMNCH specific services;
    <br> &nbsp; &nbsp; - c) RMNCH specific workforce capacity building, ensuring skilled and motivated health workers in the right place at the right time, with the necessary infrastructure, drugs, equipment and regulations.
    <br>Note: as good practice, in their project text, donors should indicate which of the above criteria is addressed in their activity
    <br>
    <br><u>Examples of typical activities</u>
    <br>Essential interventions and services such as:
    <br> &nbsp; &nbsp; - Family planning, contraception; Antenatal, newborn, and postnatal care; Emergency obstetric and newborn care; Skilled care during childbirth at appropriate facilities; Safe abortion services (where not prohibited by law); Prevention of mother to child transmission of HIV and other STIs; Combating reproductive tract infections, reproductive health-related cancers, and other gynaecological morbidities; Infertility treatment; Prevention and treatment for major childhood illnesses including acute respiratory infections and diarrhoea; Improving infant and child feeding practices; Promoting exclusive breast-feeding; Providing ready-to use therapeutic foods and key vitamins and minerals, including Vitamin A and iodized salts.
    <br>Health Systems Strengthening:
    <br> &nbsp; &nbsp; - Removal of financial, social, and cultural barriers to access health care (including advocacy); Improving service delivery to RMNCH and increasing access to adequately equipped health centres; Supporting national plans and priorities regarding RMNCH; Implementing monitoring and evaluation mechanisms; Training, retraining and deploying health workers.
    <br>These activities contribute to the RMNCH-continuum of care through important interventions outside the health sector:
    <br> &nbsp; &nbsp; - Promotion of standards of comprehensive sexual education; Targeted food security programmes tailored to the needs of pregnant women, mothers and their children;
    <br> &nbsp; &nbsp; - Programmes that address most vulnerable population groups, such as internally displaced persons or ethnic minorities that suffer from displacement, with regard to their sexual and reproductive health needs; Improving access to clean water and hygienic sanitation for pregnant women, mothers and their children; Provision of maternal and child health services such as birthing kits or the dispatch of midwives and obstetricians which forms part of humanitarian aid emergency response; Collection of census data where specific development has occurred to target accurate reporting of vitals, i.e. the number of births and the number of  live  births.
",
  biodiversity = "
    <br><b>General reporting information</b>
    <br>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Hungary and Estonia</b>, as the donor did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Iceland</b> started to report on this marker in <b>2013</b> (on 2012 flows).
    <br> &nbsp; &nbsp; - <b>Slovak Republic and Poland</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Estonia</b> started to report on this marker in <b>2017</b> (on 2016 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br>
    <br><b>Methodology used for the policy objective: Convention on Biological Diversity (CBD) - Biodiversity</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>biodiversity-related</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; -It promotes at least one of the three objectives of the Convention: the conservation of biodiversity, sustainable use of its components (ecosystems, species or genetic resources), or fair and equitable sharing of the benefits of the utilisation of genetic resources
    <br>
    <br><u>Criteria for eligibility</u>
    <br>The activity contributes to
    <br> &nbsp; &nbsp; a) protection or enhancing ecosystems, species or genetic resources through in-situ or ex-situ conservation, or remedying existing environmental damage; or
    <br> &nbsp; &nbsp; b) integration of biodiversity and ecosystem services concerns within recipient countries  development objectives and economic decision making, through institution building, capacity development, strengthening the regulatory and policy framework, or research; or
    <br> &nbsp; &nbsp; c) developing countries  efforts to meet their obligations under the Convention
    <br>The activity will score <b>principal objective</b> if it directly and explicitly aims to achieve one or more of the above three criteria.
    <br>
    <br><u>Examples of typical activities</u>
    <br><i><u>1. Typical activities take place in the sectors of:</i></u>
    <br>Integration of biological diversity concerns into sectoral policy, planning and programmes; e.g.
    <br> &nbsp; &nbsp; - Water and sanitation: Water resources protection and rehabilitation; integrated watershed, catchment and river basin protection and management;
    <br> &nbsp; &nbsp; - Agriculture: Sustainable agricultural and farming practices including substitution of damaging uses and extractions by out-of-area plantations, alternative cultivation or equivalent substances; integrated pest management strategies; soil conservation; in-situ conservation of genetic resources; alternative livelihoods;
    <br> &nbsp; &nbsp; - Forestry: Combating deforestation and land degradation while maintaining or enhancing biodiversity in the affected areas;
    <br> &nbsp; &nbsp; - Fishing: Promotion of sustainable marine, coastal and inland fishing;
    <br> &nbsp; &nbsp; - Tourism: Sustainable use of sensitive environmental areas for tourism.
    <br><i><u>2. Typical non-sector specific activities are:</i></u>
    <br> &nbsp; &nbsp; - Environmental policy and  administrative management: Preparation of national biodiversity plans, strategies and programmes; biodiversity inventories and assessments; development of legislation and regulations to protect threatened species; development of incentives, impact assessments, and policy and legislation on equitable access to the benefits of genetic resources.
    <br> &nbsp; &nbsp; - Biosphere and biodiversity protection: Establishment of protected areas, environmentally oriented zoning, land use and regional development planning; Protecting endangered or vulnerable species and their habitats, e.g. by promoting traditional animal husbandry or formerly cultivated/collected plants or ex-situ conservation (e.g. seed banks, zoological gardens).
    <br> &nbsp; &nbsp; - Environmental education/  training: Capacity building in taxonomy, biodiversity assessment and information management of biodiversity data; education, training and awareness raising on biodiversity.
    <br> &nbsp; &nbsp; - Environmental research: Research on ecological, socio-economic and policy issues related to biodiversity, including research on and application of knowledge of indigenous people; Supporting development and use of approaches, methods and tools for assessment, valuation and sustaining of ecosystem services.
    <br>
    <br><i><b>Important note:</b>  Biodiversity (CRS sector code 41030) scores, by definition, principal objective.</i>
    <br>",
  climate_mitigation = "
    <br><b>General reporting information</b>
    <br>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Hungary ad Estonia</b>, as the donor did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Iceland</b> started to report on this marker in <b>2013</b> (on 2012 flows).
    <br> &nbsp; &nbsp; - <b>Slovak Republic and Poland</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Estonia</b> started to report on this marker in <b>2021</b> (on 2020 flows).
    <br>
    <br><b>Methodology used for the policy objective: United Nations Framework Convention on Climate Change (UNFCCC) - Climate change mitigation</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>climate change-mitigation related</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It contributes to the objective of stabilisation of greenhouse gas (GHG) concentrations in the atmosphere at a level that would prevent dangerous anthropogenic interference with the climate system by promoting efforts to reduce or limit GHG emissions or to enhance GHG sequestration.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>The activity contributes to
    <br> &nbsp; &nbsp; a) the mitigation of climate change by limiting anthropogenic emissions of GHGs, including gases regulated by the Montreal Protocol; or
    <br> &nbsp; &nbsp; b) the protection and/or enhancement of GHG sinks and reservoirs; or
    <br> &nbsp; &nbsp; c) the integration of climate change concerns with the recipient countries  development objectives through institution building, capacity development, strengthening the regulatory and policy framework, or research; or
    <br> &nbsp; &nbsp; d) developing countries  efforts to meet their obligations under the Convention.
    <br>The activity will score <b> principal objective </b> if it directly and explicitly aims to achieve one or more of the above four criteria.
    <br>
    <br><u>Examples of typical activities</u>
    <br><i><u>1. Typical activities take place in the sectors of:</i></u> Water and sanitation; Transport; Energy; Agriculture; Forestry; Industry
    <br> &nbsp; &nbsp; - GHG emission reductions or stabilisation in the energy, transport, industry and agricultural sectors through application of new and renewable forms of energy, measures to improve the energy efficiency of existing generators, machines and equipment, or demand side management.
    <br> &nbsp; &nbsp; - Methane emission reductions through waste management or sewage treatment.
    <br> &nbsp; &nbsp; - Development, transfer and promotion of technologies and know-how as well as building of capacities that control, reduce or prevent anthropogenic emissions of GHGs, in particular in waste management, transport, energy, agriculture and industry.
    <br> &nbsp; &nbsp; - Protection and enhancement of sinks and reservoirs of GHGs through sustainable forest management, afforestation and reforestation, rehabilitation of areas affected by drought and desertification.
    <br><i><u>2. Typical non-sector specific activities are:</i></u> Environmental policy and administrative management; Biosphere protection; Biodiversity; Env. education/training; Environmental research
    <br> &nbsp; &nbsp; - Protection and enhancement of sinks and reservoirs through sustainable management and conservation of oceans and other marine and coastal ecosystems, wetlands, wilderness areas and other ecosystems.
    <br> &nbsp; &nbsp; - Preparation of national inventories of greenhouse gases (emissions by sources and removals by sinks); climate change related policy and economic analysis and instruments, including national plans to mitigate climate change; development of climate-change-related legislation; climate technology needs surveys and assessments; institutional capacity building.
    <br> &nbsp; &nbsp; - Education, training and public awareness related to climate change.
    <br> &nbsp; &nbsp; - Climate-change-mitigation related research and monitoring.
    <br> &nbsp; &nbsp; - Oceanographic and atmospheric research and monitoring.
    <br>",
  climate_adaptation = "
    <br><b>General reporting information</b>
    <br>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Hungary and Estonia</b>, as the donor did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Iceland</b> started to report on this marker in <b>2013</b> (on 2012 flows).
    <br> &nbsp; &nbsp; - <b>Slovak Republic and Poland</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Estonia</b> started to report on this marker in <b>2021</b> (on 2020 flows).
    <br>
    <br><b>Methodology used for the policy objective: United Nations Framework Convention on Climate Change (UNFCCC) - Climate change adaptation</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>climate change-adaptation related</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It intends to reduce the vulnerability of human or natural systems to the impacts of climate change and climate-related risks, by maintaining or increasing adaptive capacity and resilience.
    <br> &nbsp; &nbsp; - This encompasses a range of activities from information and knowledge generation, to capacity development, planning and the implementation of climate change adaptation actions.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>An activity is eligible for the climate change adaptation marker if:
    <br> &nbsp; &nbsp; a) the climate change adaptation objective is explicitly indicated in the activity documentation; and
    <br> &nbsp; &nbsp; b) the activity contains specific measures targeting the definition above.
    <br>Carrying out a climate change adaptation analysis, either separately or as an integral part of agencies  standard procedures, facilitates this approach.
    <br>
    <br><u>Examples of typical activities</u>
    <br>The list is not exhaustive. The activities may be scored against the objective only if the above criteria for eligibility are fulfilled.
    <br><i><u>1. Typical activities take place in the sectors of:</i></u>
    <br> &nbsp; &nbsp; - Environmental policy and administrative management (sector 41010): Supporting the integration of climate change adaptation into national and international policy, plans and programmes; Improving regulations and legislation to provide incentives to adapt.
    <br> &nbsp; &nbsp; - Environmental education / training (sector 41081): Education, training and public awareness raising related to the causes and impacts of climate change and the role of adaptation.
    <br> &nbsp; &nbsp; - Environmental research (sector 41082): Adaptation-related climate research including meteorological and hydrological observation and forecasting, impact and vulnerability assessments, early warning systems, etc
    <br><i><u>2. Typical non-sector specific activities are:</i></u>
    <br> &nbsp; &nbsp; - Health (Sector 120): Implementing measures to control malaria in areas threatened by increased incidence of diseases due to climate change.
    <br> &nbsp; &nbsp; - Water and sanitation (Sector 140): Promoting water conservation in areas where enhanced water stress due to climate change is anticipated.
    <br> &nbsp; &nbsp; - Agriculture (Sector 311): Promoting heat and drought resistant crops and water saving irrigation methods to withstand climate change.
    <br> &nbsp; &nbsp; - Forestry (Sector 312): Promoting a diverse mix of forest management practices and species to provide a buffer against uncertainties of climate change.
    <br> &nbsp; &nbsp; - Fishing (Sector 313): Promoting changes in fishing practices to adapt to changes in stocks and target species. Introducing flexibility in the gear that is used, the species that are fished, the fishing areas to be managed, and the allocations that are harvested.
    <br> &nbsp; &nbsp; - Flood prevention/control (Sector 41050 - under General environmental protection): Implementing measures for flood prevention and management such as watershed management, reforestation or wetland restoration.
    <br> &nbsp; &nbsp; - Disaster prevention and preparedness (Sector 740): Developing emergency prevention and preparedness measures including insurance schemes to cope with potential climatic disasters; Implementing measures to respond to glacial lake outburst flood risk, such as the creation or improvement of early warning systems and widening or deepening of glacial lake outlet channels.
    <br>",
  desertification = "
    <br><b>General reporting information</b>
    <br>
    <br> &nbsp; &nbsp; - Data are not shown for <b>France, Hungary, Estonia and the United States</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Iceland</b> started to report on this marker in <b>2013</b> (on 2012 flows).
    <br> &nbsp; &nbsp; - <b>Slovak Republic and Poland</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Estonia</b> started to report on this marker in <b>2021</b> (on 2020 flows).
    <br> &nbsp; &nbsp; - <b>Slovenia</b> started to report on this marker in <b>2022</b> (on 2021 flows).
    <br> &nbsp; &nbsp; - <b>The United States</b> do not report on this marker.
    <br>
    <br><b>Methodology used for the policy objective: United Nations Convention to Combat Desertification (UNCCD) - Desertification</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>desertification related</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It aims at combating desertification or mitigating the effects of drought in arid, semi arid and dry sub-humid areas through prevention and/or reduction of land degradation, rehabilitation of partly degraded land, or reclamation of desertified land.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>The activity contributes to
    <br> &nbsp; &nbsp; a) protecting or enhancing dryland ecosystems or remedying existing environmental damage; or
    <br> &nbsp; &nbsp; b) integration of desertification concerns with recipient countries  development objectives through institution building, capacity development, strengthening the regulatory and policy framework, or research; or
    <br> &nbsp; &nbsp; c) developing countries  efforts to meet their obligations under the Convention.
    <br><i>The activity will score  principal objective  if it directly and explicitly relates to one or more of the above criteria, including in the context of the realisation of national, sub-regional or regional action programmes.</i>
    <br>
    <br><u>Examples of typical activities</u>
    <br><i><u>1. Typical activities take place in the sectors of:</i></u> Water and sanitation; Agriculture; Forestry
    <br> &nbsp; &nbsp; - Integration of action to combat desertification and land degradation into sectoral policy, planning and programmes (e.g. agricultural and rural development policy, plans and programmes);
    <br> &nbsp; &nbsp; - Rehabilitation of land, vegetation cover, forests and water resources, conservation and sustainable management of land and water resources;
    <br> &nbsp; &nbsp; - Sustainable irrigation for both crops and livestock to reduce pressure on threatened land; alternative livelihood projects;
    <br> &nbsp; &nbsp; - Development and transfer of environmentally sound traditional and local technologies, knowledge, know-how and practices to combat desertification, e.g. methods of conserving water, wood (for fuel or construction) and soil in dry areas
    <br><i><u>2. Typical non-sector specific activities are:</i></u> Environmental policy and administrative management; Env. education/training; Environmental research
    <br> &nbsp; &nbsp; - Preparation of strategies and action programmes to combat desertification and mitigate the effects of drought; establishment of drought early warning systems; strengthening of drought preparedness and management; observation and assessment of CCD implementation, including monitoring and evaluation of impact indicators;
    <br> &nbsp; &nbsp; - Measures to promote the participation of affected populations in planning and implementing sustainable resource management or improving security of land tenure;
    <br> &nbsp; &nbsp; - Support for population/migration policies to reduce population pressure on land;
    <br> &nbsp; &nbsp; - Capacity building in desertification monitoring and assessment; education, training and public awareness programmes related to desertification and land degradation;
    <br> &nbsp; &nbsp; - Research on desertification and land degradation
    <br>",
  environment = "
    <br><b>General reporting information</b>
    <br>
    <br>Data are not shown for <b>Hungary and Latvia</b>, as the donor did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Estonia, Poland,  and the Slovak Republic</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2018</b> (on 2017 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2019</b> (on 2018 flows).
    <br>
    <br><b>Methodology used for the policy objective: Aid to environment</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>environment-oriented</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; a) It is intended to produce an improvement, or something that is diagnosed as an improvement, in the physical and/or biological environment of the recipient country, area or target group concerned;
    <br> &nbsp; &nbsp; or
    <br> &nbsp; &nbsp; b) It includes specific action to integrate environmental concerns with arange of development objectives through institution building and/or capacity development.
    <br>
    <br><u>Criteria for eligibility</u>
    <br> &nbsp; &nbsp; a) The objective is explicitly promoted in activity documentation;
    <br> &nbsp; &nbsp; and
    <br> &nbsp; &nbsp; b) The activity contains specific measures to protect or enhance the physical and/or biological environment it affects, or to remedy existing environmental damage;
    <br> &nbsp; &nbsp; or
    <br> &nbsp; &nbsp; c) The activity contains specific measures to develop or strengthen environmental policies, legislation and administration or other organisations responsible for environmental protection.
    <br>
    <br><u>Examples of typical activities</u>
    <br>The list is not exhaustive. The activities may be scored against the objective only if the above criteria for eligibility are fulfilled.
    <br> &nbsp; &nbsp; - Social infrastructure and services: Water resources protection; water resources policies and water management that take into account environmental and socio-economic constraints, sanitation or waste management practices that bring environmental benefits.
    <br> &nbsp; &nbsp; - Economic infrastructure and services: Infrastructure projects designed with comprehensive and integrated environmental protection and management components; activities promoting sustainable use of energy resources (power generation from renewable sources of energy); energy conservation.
    <br> &nbsp; &nbsp; - Production sectors: Sustainable management of agricultural land and water resources; sustainable forest management programmes, combating land degradation and deforestation; sustainable management of sea resources; adoption and promotion of cleaner and more efficient technologies in production processes; measures to suppress or reduce pollution in land, water and air (e.g. filters); increasing energy efficiency in industries; sustainable use of sensitive environmental areas for tourism. (Sustainable natural resources management is a combination of management practices that have been planned and selected on the basis of interdisciplinary and participatory assessment of ecological, social and economic impacts of alternative management options, and resolution of possible conflicts or disputes concerning the significance and acceptability of the impacts of the proposed management alternatives.)
    <br>
    <br><b><i> Important note:</b> Activities that can be assigned the sector code .general environmental protection. i.e. environmental policy and administrative management, biosphere protection, biodiversity, site preservation, flood prevention/control, environmental education/training, environmental research score, by definition, principal objective.</i>
    <br>",
  dig = "
    <br><b>General reporting information</b>
    <br>
    <br>/!\ Please note that some analysis are using disbursements. This dashboard is only showing <b>commitments</b>.
    <br> &nbsp; &nbsp; - Data are not shown for <b>Belgium, Latvia, and the United Kingdom</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Australia and Iceland</b> started to report on this marker in <b>2013</b> (on 2012 flows).
    <br> &nbsp; &nbsp; - <b>Estonia, Poland and the Slovak Republic</b> started to report on this marker in <b>2014</b> (on 2013 flows).
    <br> &nbsp; &nbsp; - <b>Lithuania</b> started to report on this marker in <b>2015</b> (on 2014 flows).
    <br> &nbsp; &nbsp; - <b>Latvia</b> started to report on this marker in <b>2017</b> (on 2016 flows).
    <br> &nbsp; &nbsp; - <b>Hungary</b> started to report on this marker in <b>2019</b> (on 2018 flows).
    <br>
    <br><b>Methodology used for the policy objective: Democratic and inclusive governance (DIG)</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>governance-oriented</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It is intended to enhance fundamental elements of democratic and inclusive governance across all areas of development co-operation.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>(a) The objectives are explicitly promoted in activity documentation; and
    <br>(b) The activity contains specific measures to promote one or several of the governance aspects defined as follows:
    <br> &nbsp; &nbsp; - Participatory development includes efforts to support inclusive participation and equal representation of citizens in decision-making processes as well as support to institutions to expand the coverage, quality and/or use of public goods and services. This includes, in particular, efforts to improve the participation of marginalised and vulnerable groups, in line with the principle of leaving no-one behind.
    <br> &nbsp; &nbsp; - Democratisation, includes support to promote horizontal and vertical accountability, comprising efforts to improve institutional checks and balances within the state, credible elections and support to elected bodies as well as and support to citizen engagement and media.
    <br> &nbsp; &nbsp; - Good governance, includes efforts to uphold a fair rule of law, improve transparency in the management of public affairs, and combat corruption and illicit financial flows.
    <br> &nbsp; &nbsp; - Human rights, includes measures that directly aim to better guarantee internationally agreed civil and political rights, including the right to security and peace, freedom of expression and freedom of assembly. Also covers human rights based programming approaches that aim to expand social services.
    <br>
    <br><u>Examples of typical activities</u>
    <br>The list is not exhaustive. The activities may be scored against the objective only if the above criteria for eligibility are fulfilled.
    <br> &nbsp; &nbsp; - Institutional reforms that improve government accountability and transparency.
    <br> &nbsp; &nbsp; - Programmes that improve access to justice.
    <br> &nbsp; &nbsp; - Support to civil society organisations to improve citizen participation in governance processes.
    <br> &nbsp; &nbsp; - Support to improve the quality and integrity of electoral processes.
    <br> &nbsp; &nbsp; - Support to decentralisation processes.
    <br> &nbsp; &nbsp; - Civic education on social, economic and political rights.
    <br> &nbsp; &nbsp; - Building inclusive green cities.
    <br> &nbsp; &nbsp; - Empowering communities for climate resilience.
    <br> &nbsp; &nbsp; - Programmes that promote anti-corruption measures.
    <br> &nbsp; &nbsp; - Support to education reform programmes that turn the sector more inclusive.
    <br> &nbsp; &nbsp; - Support to multi-actor dialogue processes in various sectors (trade, agriculture, water & sanitation etc.).
    <br><u>Examples of activities that do not qualify</u>:
    <br> &nbsp; &nbsp; - Construction of government buildings
    <br> &nbsp; &nbsp; - Technical feasibility studies or surveys
    <br>
    <br> Handbook : The OECD-DAC policy marker on Democratic and Inclusive Governance (DIG) (https://one.oecd.org/document/DCD/DAC/GOVNET(2022)2/en/pdf)
  ",
  drr = "
    <br><b>General reporting information</b>
    <br>
    <br> This policy marker was first introduced in 2019 on 2018 flows.
    <br> &nbsp; &nbsp; - Data are not shown for <b>Belgium, Germany, Luxembourg, Hungary and Luxembourg</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Belgium, Hungary, Lithuania, and the United Kingdom</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Denmark</b> started to report on this marker in <b>2021</b> (on 2020 flows).
    <br> &nbsp; &nbsp; - <b>Germany and Estonia</b> started to report on this marker in <b>2023</b> (on 2022 flows).
    <br>
    <br><b>Methodology used for the policy objective: Sendai Framework for Disaster Risk Reduction (DRR)</b>
    <br>
    <br><u>Definition</u>
    <br>An activity should be classified as <b>DRR-related</b> (<i>score Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - It promotes the goal and global targets* of the Sendai Framework to achieve substantial reduction of disaster risk and losses in lives, livelihoods and health and in the economic, physical, social, cultural and environmental assets of persons, businesses, communities and countries.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>The activity contributes to:
    <br> &nbsp; &nbsp; a) the prevention of new disaster risk, and/or
    <br> &nbsp; &nbsp; b) the reduction of existing disaster risk, and/or
    <br> &nbsp; &nbsp; c) the strengthening of resilience through the implementation of integrated and inclusive economic, structural, legal, social, health, cultural, educational, environmental, technological, political and institutional measures that prevent and reduce hazard exposure and vulnerability to disaster, and increase preparedness for response and recovery with the explicit purpose of increasing human security, well-being, quality of life, resilience, and sustainable development.
    <br>The activity will score  principal objective  if it directly and explicitly contributes to at least one of the four Priorities for Action of the Sendai Framework:
    <br> &nbsp; &nbsp; - Priority 1: Understanding disaster risk.
    <br> &nbsp; &nbsp; - Priority 2: Strengthening disaster risk governance to manage disaster risk.
    <br> &nbsp; &nbsp; - Priority 3: Investing in disaster risk reduction for resilience.
    <br> &nbsp; &nbsp; - Priority 4: Enhancing disaster preparedness for effective response and to  Build Back Better  in recovery, rehabilitation and reconstruction.
    <br>
    <br><u>Examples of typical activities</u>
    <br> &nbsp; &nbsp; - Support for design, implementation, and evaluation of strategies, policies, and measures to improve the understanding of disaster risk
    <br> &nbsp; &nbsp; - DRR considerations integrated into development policies, planning and legislation
    <br> &nbsp; &nbsp; - Fostering political commitment and community participation in DRR
    <br> &nbsp; &nbsp; - Multi-hazard risk mapping, modelling, assessments and dissemination
    <br> &nbsp; &nbsp; - Decision support tools for risk-sensitive planning
    <br> &nbsp; &nbsp; - Early warning systems with outreach to communities
    <br> &nbsp; &nbsp; - Developing knowledge, public awareness and co-operation on DRR
    <br> &nbsp; &nbsp; - Inclusion of DRR into curricula and capacity building for educators
    <br> &nbsp; &nbsp; - Disaster risk management training to communities, local authorities, and targeted sectors
    <br> &nbsp; &nbsp; - DRR considerations integrated with the climate change adaptation, social protection and environmental policies
    <br> &nbsp; &nbsp; - Legal norms for resilient infrastructure and land use planning
    <br> &nbsp; &nbsp; - Disaster financing and insurance
    <br> &nbsp; &nbsp; - Disaster preparedness planning and regular drills for enhancing response
    <br> &nbsp; &nbsp; - Protective infrastructure and equipment
    <br> &nbsp; &nbsp; - Resilient recovery planning and financing
    <br>
    <br><i>Notes: Disaster Risk Reduction (43060) and Multi-hazard response preparedness 74020) score, by definition, principal objective.
    <br>* The global targets of the Sendai Framework are: a) Substantially reduce global disaster mortality by 2030, aiming to lower the average per 100,000 global mortality rate in the decade 2020-2030 compared to the period 2005-2015; b) Substantially reduce the number of affected people globally by 2030, aiming to lower the average global figure per 100,000 in the decade 2020-2030 compared to the period 2005-2015; c) Reduce direct disaster economic loss in relation to global gross domestic product (GDP) by 2030; d) Substantially reduce disaster damage to critical infrastructure and disruption of basic services, among them health and educational facilities, including through developing their resilience by 2030; e) Substantially increase the number of countries with national and local disaster risk reduction strategies by 2020; f) Substantially enhance international cooperation to developing countries through adequate and sustainable support to complement their national actions for implementation of the present Framework by 2030; g) Substantially increase the availability of and access to multi-hazard early warning systems and disaster risk information and assessments to people by 2030.</i>
    <br>",
  nutrition = "
    <br><b>General reporting information</b>
    <br>
    <br>This policy marker was first introduced in 2019 on 2018 flows. <b>Reporting is voluntary.</b>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Austria, Belgium, Estonia, France, Germany, Latvia, Luxembourg, the Netherland, Norway, Portugal, Slovenia and Sweden</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Belgium, Finland, Hungary and the United Kingdom</b> started to report on this marker in <b>2020</b> (on 2019 flows).
    <br> &nbsp; &nbsp; - <b>Denmark, Germany and Portugal</b> started to report on this marker in <b>2021</b> (on 2022 flows).
    <br>
    <br><b>Methodology used for the policy objective: Nutrition</b>
    <br>
    <br><u>Definition</u>
    <br>A project should be identified as <b>nutrition</b> related with the policy marker (<i>score Principal or Significant</i>) when:
    <br> &nbsp; &nbsp; - It is intended to address the immediate or underlying determinants of malnutrition (1). This can encompass a range of projects across a variety of sectors, including humanitarian interventions, maternal health, WASH and agriculture.
    <br>
    <br><u>Criteria for eligibility</u>
    <br>A project is eligible for the nutrition policy marker if:
    <br> &nbsp; &nbsp; - It is reported under the 12240 basic nutrition purpose code
    <br> &nbsp; &nbsp; OR
    <br> &nbsp; &nbsp; - The project contributes to a nutrition-sensitive outcome 
    <br> &nbsp; &nbsp; AND 
    <br> &nbsp; &nbsp; - The project documentation includes an explicit nutrition objective or indicator.
    <br>
    <br><u>Examples of nutrition objectives and indicators*</u>
    <br><i><u>Qualifying objectives include</i></u>:
    <br> &nbsp; &nbsp; - Improve access to more diversified nutritional diets and food; Improve the nutritional status of a target population; Improve infant and young child feeding practices; Improve access to management of acute malnutrition
    <br><i><u>Qualifying indicators include</i></u>:
    <br> &nbsp; &nbsp; - Prevalence of stunting amongst children under five; Prevalence of overweight;
    <br> &nbsp; &nbsp; - Household Food Consumption Score; Household Dietary Diversity Score;
    <br> &nbsp; &nbsp; - Prevalence of severely underweight children under 5 years; % of acutely malnourished children under-5 enrolled in feeding programme; Prevalence of anaemia among women in childbearing age
    <br>
    <br><u>Examples of nutrition-sensitive outcomes*</u>
    <br><i><u>Individual level</i></u>:
    <br> &nbsp; &nbsp; - Improved access to nutritious food for women, adolescent girls and/or children;
    <br> &nbsp; &nbsp; - Improved diet in quality and/or quantity for a target population; Improved access for a target population; Improved access for a target population to water, sanitation and hygiene; Improved access to education/school for adolescent girls; Improved knowledge/awareness on nutrition for relevant audiences; Improved empowerment of women
    <br><i><u>National level</i></u>:
    <br> &nbsp; &nbsp; - Improved governance of nutrition; Increased nutrition sensitive legislation; Increased scientific research with nutrition objectives
    <br>
    <br><u>Examples of typical activities</u>*
    <br><i><u>Projects may be scored as principal or significant only if the above criteria for eligibility are fulfilled</i></u>.
    <br> &nbsp; &nbsp; - Fortification of staple foods with the aim of reducing iron and folic acid deficiency
    <br> &nbsp; &nbsp; - Management of acute malnutrition in emergency situations
    <br> &nbsp; &nbsp; - Behaviour change communication to promote exclusive breastfeeding
    <br> &nbsp; &nbsp; - Improvements in nutrition surveillance and health information systems
    <br> &nbsp; &nbsp; - Training health personnel to identify and treat nutritional deficiencies
    <br> &nbsp; &nbsp; - An integrated programme for maternal and child health that includes breastfeeding promotion, along with several other health interventions that are not directly relevant to nutrition
    <br> &nbsp; &nbsp; - A school feeding programme whose principal objective is increased school attendance, while also including explicit objectives/indicators for the dietary diversity and micronutrient-richness of school meals
    <br> &nbsp; &nbsp; - An agriculture programme whose principal objective is improving the access of smallholder farmers and women to markets, while also including explicit objectives/indicators for the availability and affordability of nutritious foods in markets
    <br> &nbsp; &nbsp; - Programmes promoting dietary diversity
    <br>
    <br><i>Notes:
    <br>*This list is not exhaustive.
    <br>(1)The immediate determinants of malnutrition include inadequate dietary intake, feeding practices or access to food. Underlying determinants of malnutrition include food security; adequate caregiving resources at the maternal, household and community levels; and access to health services and a safe and hygienic environment.</i>
",
  disability = "
    <br><b>General reporting information</b>
    <br>
    <br>This policy marker was first introduced in 2019 on 2018 flows. <b>Reporting is voluntary.</b>
    <br> &nbsp; &nbsp; - Data are not shown for <b>Belgium, Estonia, France, Germany, Hungary, Latvia, Luxembourg, the Netherlands, Portugal, Slovenia, and the United States</b>, as they did not report on the marker or their coverage was below 50% in <b>2023-2024</b>.
    <br> &nbsp; &nbsp; - <b>Denmark</b> started to report on this marker in <b>2022</b> (on 2021 flows).
    <br> &nbsp; &nbsp; - <b>Portugal</b> started to report on this marker in <b>2023</b> (on 2022 flows).
    <br> &nbsp; &nbsp; - <b>Belgium</b> started to report on this marker in <b>2024</b> (on 2023 flows).
    <br>
    <br><b>Methodology used for the policy objective: Inclusion and Empowerment of Persons with Disabilities</b>
    <br>
    <br><u>Definition</u>
    <br>In accordance with the Convention on the Rights of Persons with Disabilities (CRPD) persons with disabilities include those who have long-term physical, mental, intellectual or sensory impairments which in interaction with various barriers may hinder their full and effective participation in society on an equal basis with others
    <br>
    <br>Development co-operation activities are classified as being <b>inclusive of persons with disabilities</b> (<i>scores Principal or Significant</i>) if:
    <br> &nbsp; &nbsp; - They have a deliberate objective on ensuring that persons with disabilities are included, and able to share the benefits, on an equal basis to persons without disabilities.
    <br> &nbsp; &nbsp; or
    <br> &nbsp; &nbsp; - They contribute to promote, protect and ensure the full and equal enjoyment of all human rights and fundamental freedoms by all persons with disabilities, and promote respect for their inherent dignity in line with Art. 1 of the Convention on the Rights of Persons with Disabilities.
    <br> &nbsp; &nbsp; or
    <br> &nbsp; &nbsp; - They support the ratification, implementation and/or monitoring of the Convention on the Rights of Persons with Disabilities.
    <br>
    <br><u>Criteria for eligibility</u>
    <br> &nbsp; &nbsp; - Support to activities that contribute to respect, protection and fulfilment of the rights and inclusion of persons with disabilities, explicitly promoted in activity documentation through specific measures which:
    <br> &nbsp; &nbsp; - Promote and protect the equal enjoyment of all human rights by all persons with disabilities, and promote respect for their inherent dignity (CRPD Art. 1).
    <br> &nbsp; &nbsp; - Ensure empowerment and accessibility for persons with disabilities to the physical, social, economic and cultural environment, to health and education and to information and communication.
    <br> &nbsp; &nbsp; - Promote social, economic or political inclusion of persons with disabilities; or develop or strengthen policies, legislation or institutions in support of effective participation in society of persons with disabilities and/or their representative organisations
    <br>
    <br><i><u>Examples of activities that could be marked as principal (score 2) objective include</i></u>:
    <br> &nbsp; &nbsp; - Support to inclusive education as defined by art 24 of the CRPD.
    <br> &nbsp; &nbsp; - Support to job insertion programmes inclusive of persons with disabilities.
    <br> &nbsp; &nbsp; - Support to health and social projects specifically designed to reduce the vulnerability of the persons with disabilities.
    <br> &nbsp; &nbsp; - Support to reduce architectural barriers in urban areas
    <br>
    <br><i><u>Examples of activities that could be marked as significant (score 1) objective include</i></u>:
    <br> &nbsp; &nbsp; - A new or refurbished infrastructure project that is fully accessible to persons with disabilities.
    <br> &nbsp; &nbsp; - A local library/school that makes cultural and education material also available in a form accessible to persons with visual or hearing impairments.
    <br> &nbsp; &nbsp; - A social inclusion project that includes persons with disabilities among the target groups.
    <br>
    <br><i><u>Examples of activities that could be marked as non-targeted (score 0)</i></u>:
    <br> &nbsp; &nbsp; - A programme or activity aimed at improving basic services for the poor that states that it will also reach persons with disabilities because they tend to be amongst the poorest, but does not contain specific mechanisms or activities to ensure inclusion.
    <br> &nbsp; &nbsp; - A programme establishing a segregated school for children with disabilities."
)

# Mapping colors ----------------------------------------------------------


color_mapping3 <- list(
  gender = c("#353C61", "#8C98AE", "#C2D8E6"),
  rmnch = c("#353C61", "#8C98AE", "#C2D8E6"),
  biodiversity = c("#353C61", "#8C98AE", "#C2D8E6"),
  climate_mitigation = c("#353C61", "#8C98AE", "#C2D8E6"),
  climate_adaptation = c("#353C61", "#8C98AE", "#C2D8E6"),
  desertification = c("#353C61", "#8C98AE", "#C2D8E6"),
  environment = c("#353C61", "#8C98AE", "#C2D8E6"),
  dig = c("#353C61", "#8C98AE", "#C2D8E6"),
  drr = c("#353C61", "#8C98AE", "#C2D8E6"),
  nutrition = c("#353C61", "#8C98AE", "#C2D8E6"),
  disability = c("#353C61", "#8C98AE", "#C2D8E6")
)

color_mapping4 <- list(
  gender = c("#232A52", "#6A738F", "#AFBCCC"),
  rmnch = c("#232A52", "#6A738F", "#AFBCCC"),
  biodiversity = c("#232A52", "#6A738F", "#AFBCCC"),
  climate_mitigation = c("#232A52", "#6A738F", "#AFBCCC"),
  climate_adaptation = c("#232A52", "#6A738F", "#AFBCCC"),
  desertification = c("#232A52", "#6A738F", "#AFBCCC"),
  environment = c("#232A52", "#6A738F", "#AFBCCC"),
  dig = c("#232A52", "#6A738F", "#AFBCCC"),
  drr = c("#232A52", "#6A738F", "#AFBCCC"),
  nutrition = c("#232A52", "#6A738F", "#AFBCCC"),
  disability = c("#232A52", "#6A738F", "#AFBCCC")
)

color_mapping2 <- list(
  gender = c("#353C61", "#C2D8E6"),
  rmnch = c("#353C61", "#C2D8E6"),
  biodiversity = c("#353C61", "#C2D8E6"),
  climate_mitigation = c("#353C61", "#C2D8E6"),
  climate_adaptation = c("#353C61", "#C2D8E6"),
  desertification = c("#353C61", "#C2D8E6"),
  environment = c("#353C61", "#C2D8E6"),
  dig = c("#353C61", "#C2D8E6"),
  drr = c("#353C61", "#C2D8E6"),
  nutrition = c("#353C61", "#C2D8E6"),
  disability = c("#353C61", "#C2D8E6")
)

color_mapping1 <- list(
  gender = c("#6A738F"),
  rmnch = c("#6A738F"),
  biodiversity = c("#6A738F"),
  climate_mitigation = c("#6A738F"),
  climate_adaptation = c("#6A738F"),
  desertification = c("#6A738F"),
  environment = c("#6A738F"),
  dig = c("#6A738F"),
  drr = c("#6A738F"),
  nutrition = c("#6A738F"),
  disability = c("#6A738F")
)

# 
# color_mapping3 <- list(
#   gender = c("#850303", "#C25655", "#FFA9A6"),
#   rmnch = c("#850303", "#C25655", "#FFA9A6"),
#   biodiversity = c("#C5E0B4", "#385723", "#70AD47"),
#   climate_mitigation = c("#C5E0B4", "#385723", "#70AD47"),
#   climate_adaptation = c("#C5E0B4", "#385723", "#70AD47"),
#   desertification = c("#C5E0B4", "#385723", "#70AD47"),
#   environment = c("#C5E0B4", "#385723", "#70AD47"),
#   dig = c("#353C61", "#6A738F", "#C2D8E6"),
#   drr = c("#353C61", "#6A738F", "#C2D8E6"),
#   nutrition = c("#B13B10", "#D88F57", "#E5DC89"),
#   disability = c("#B13B10", "#D88F57", "#E5DC89")
# )
# 
# color_mapping2 <- list(
#   gender = c("#850303", "#FFA9A6"),
#   rmnch = c("#850303", "#FFA9A6"),
#   biodiversity = c("#C5E0B4", "#385723"),
#   climate_mitigation = c("#C5E0B4", "#385723"),
#   climate_adaptation = c("#C5E0B4", "#385723"),
#   desertification = c("#C5E0B4", "#385723"),
#   environment = c("#C5E0B4", "#385723"),
#   dig = c("#353C61", "#C2D8E6"),
#   drr = c("#353C61", "#C2D8E6"),
#   nutrition = c("#B13B10", "#E5DC89"),
#   disability = c("#B13B10", "#E5DC89")
# )
# 
# color_mapping1 <- list(
#   gender = c("#C25655"),
#   rmnch = c("#C25655"),
#   biodiversity = c("#70AD47"),
#   climate_mitigation = c("#70AD47"),
#   climate_adaptation = c("#70AD47"),
#   desertification = c("#70AD47"),
#   environment = c("#70AD47"),
#   dig = c("#6A738F"),
#   drr = c("#6A738F"),
#   nutrition = c("#D88F57"),
#   disability = c("#D88F57")
# )
