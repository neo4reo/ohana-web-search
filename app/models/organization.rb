require 'json'

class Organization

  # Calls the search endpoint of the Ohana API
  #
  # If params doesn't include at least one of keyword, location,
  # or language, the wrapper will return a BadRequest error,
  # which we can rescue and inspect. If the error message includes
  # "missing", that means one of the required params is missing,
  # and we can choose to display all locations in that case.
  # Otherwise, it's either because the location or radius is invalid,
  # in which case we return an empty result.
  #
  # @param params [Hash] Search options.
  # @return [Array] Array of locations.
  def self.search(params = {})
    begin
      Ohanakapa.search("search", params)
    rescue Ohanakapa::BadRequest => e
      if e.to_s.include?("missing")
        Ohanakapa.locations(params)
      else
        Ohanakapa.search("search", keyword: "asdfasg")
      end
    end
  end

  # Calls the locations/{id} endpoint of the Ohana API
  # Fetches a single location by id
  #
  # If the id doesn't correspond to an existing location the wrapper
  # will return a NotFound error, which we need to rescue and deal with
  # appropriately by redirecting to a custom 404 page or to the home page
  # with an alert.
  #
  # @param id [String] Location id.
  # @return [Sawyer::Resource] Hash of location details.
  def self.get(id)
    begin
      Ohanakapa.location(id)
    rescue Ohanakapa::NotFound
      return false
    end
  end

  # Provides temporary custom CIP > OE mapping of search terms that don't return results
  # If the response content is blank (no results found) check that the keyword isn't
  # one of the homepage terms, and if so, map to a new search that returns at least one result
  # @param query [Object] The original query.
  # @param keyword [String] A keyword entered by the user.
  def self.keyword_mapping(params)
    keyword = params[:keyword].downcase
    new_params = params.dup

    if keyword == 'animal welfare'
      new_params[:keyword] = 'protective services for animals'
    elsif keyword == 'building support networks'
      new_params[:keyword] = 'support groups'
    elsif keyword == 'daytime caregiving'
      new_params[:keyword] = 'day care'
    elsif keyword == 'help navigating the system'
      new_params[:keyword] = '211'
    elsif keyword == 'residential caregiving'
      new_params[:keyword] = 'palliative care'
    elsif keyword == 'help finding school'
      new_params[:keyword] = 'school enrollment and curriculum'
    elsif keyword == 'help paying for school'
      new_params[:keyword] = 'money management'
    elsif keyword == 'disaster response'
      new_params[:keyword] = "disaster preparedness"
    elsif keyword == 'immediate safety needs'
      new_params[:keyword] = 'shelter/refuge'
    elsif keyword == 'psychiatric emergencies'
      new_params[:keyword] = 'psychiatric emergency room care'
    elsif keyword == 'food benefits'
      new_params[:keyword] = 'human/social services issues'
    elsif keyword == 'food delivery'
      new_params[:keyword] = "meal sites/home-delivered meals"
    elsif keyword == 'free meals'
      new_params[:keyword] = 'food pantries'
    elsif keyword == 'help paying for food'
      new_params[:keyword] = 'money management'
    elsif keyword == 'nutrition support'
      new_params[:keyword] = 'nutrition'
    elsif keyword == 'baby supplies'
      new_params[:keyword] = "UCSF Women's Health Resource Center"
    elsif keyword == 'toys and gifts'
      new_params[:keyword] = 'Community Services Agency of Mountain View'
    elsif keyword == 'addiction & recovery'
      new_params[:keyword] = 'addictions/dependencies support groups'
    elsif keyword == 'help finding services'
      new_params[:keyword] = '211'
    elsif keyword == 'help paying for healthcare'
      new_params[:keyword] = 'health screening/diagnostic services'
    elsif keyword == 'help finding housing'
      new_params[:keyword] = 'housing counseling'
    elsif keyword == 'housing advice'
      new_params[:keyword] = 'housing counseling'
    elsif keyword == 'paying for housing'
      new_params[:keyword] = 'housing expense assistance'
    elsif keyword == 'pay for childcare'
      new_params[:keyword] = 'money management'
    elsif keyword == 'pay for food'
      new_params[:keyword] = 'money management'
    elsif keyword == 'pay for housing'
      new_params[:keyword] = 'money management'
    elsif keyword == 'pay for school'
      new_params[:keyword] = 'money management'
    elsif keyword == 'health care reform'
      new_params[:keyword] = 'health insurance information/counseling'
    elsif keyword == 'market match'
      new_params[:keyword] = "market"
    elsif keyword == "senior farmers' market nutrition program"
      new_params[:keyword] = "market"
    elsif keyword == "sfmnp"
      new_params[:keyword] = "market"
    elsif keyword == "bus passes"
      new_params[:keyword] = 'transportation passes'
    elsif keyword == "transportation to appointments"
      new_params[:keyword] = 'transportation services'
    elsif keyword == "transportation to healthcare"
      new_params[:keyword] = 'transportation services'
    elsif keyword == "transportation to school"
      new_params[:keyword] = 'transportation services'
    elsif keyword == "citizenship & immigration"
      new_params[:keyword] = 'citizenship and immigration'
    end

    if (params[:keyword] != new_params[:keyword])
      query = search(new_params)
    end
    query
  end



  # placeholder methods for returning content for autocomplete functionality.
  # data is hardcoded here till it can be returned from the API or otherwise delivered, if applicable.

  # keyword search autocomplete data
  def self.keywords
    cip_keywords = ["211","911 Services","ADA Implementation Assistance","ADMINISTRATION AND PLANNING SERVICES","ADULT PROTECTION AND CARE SERVICES","AIDS/HIV Issues","AIDS/HIV/STD Prevention Kits","ALCOHOLISM SERVICES","Abortion Information","Abortion Isues","Abortion Services","Abortions","Abuse Counseling","Accessibility Information","Active Military","Acupuncture","Acute or Sub-acute Treatment","Addiction/Dependencies Issues","Addictions/Dependencies Support Groups","Administration and Planning","Administrative Entities","Adolescent Medicine","Adolescent/Youth Counseling","Adolescents","Adoption","Adoption Services","Adoptive Parent/Child Search","Adult","Adult Child Abuse Survivors","Adult Day Care","Adult Day Health Care","Adult Day Health Programs","Adult Day Programs","Adult Residential Care Homes","Adult Residential Treatment Facilities","Adult/Child Mentoring Programs","Adults","Adults With Disabilities","Advisory Boards","Advocacy","African American Community","Agricultural Pest/Disease Control Assistance","Agricultural Pollution Prevention/Mitigation Assistance","Airports","Alcohol Abuse Issues","Alcohol Dependency Support Groups","Alcohol Detoxification","Alcohol/Drug Impaired Driving Prevention","Alcoholism Counseling","Alternative","Alternative ","Alternative Health Care","Alzheimer's Disease","Amateur Athletic Associations","Anger Management","Animal Adoption","Animal Rescue","Animal Services","Animal/Pet Issues","Anxiety Disorders","Aquatic Therapy","Architects","Art Galleries/Exhibits","Art Therapy","Artist Services","Arts Centers","Arts and Crafts","Arts and Culture","Asian Community","Assistive/Medical Aids","At Risk Populations","Attendant Registries","Attention Deficit/Hyperactivity Disorder","Autism","Automobile Loans","Auxiliaries","Ballet Performances","Bankruptcy Courts","Bathing Facilities","Beer/Liquor Licenses and Permits","Bereavement Counseling","Bereavement Support Groups","Better Business Bureaus","Birth Certificates","Birth Control","Blindness","Blood Banks","Blood and Tissue Banks","Boards of Education","Bone Marrow Donation Registries","Book Distribution Programs","Boxing","Boys","Boys/Girls Clubs","Brain Injury Rehabilitation","Breast Cancer","Breastfeeding","Brown Bag Food Programs","Building Code Enforcement/Appeals","Building Inspection","Business Assistance Volunteer Opportunities","Business Associations","Business Consulting Services","CFIDS","CHILD PROTECTION AND CARE SERVICES","COMMODITY SERVICES","COMMUNITY SERVICES","Camperships","Camping","Camps","Career Counseling","Career Development","Case Management","Case/Care Management","Cash Assistance Program for Immigrants","Centers for Independent Living","Certificates/Forms Assistanc","Certificates/Forms Assistance","Chambers of Commerce","Charities/Foundations/Funding Organizations","Child Abuse Hotlines","Child Abuse Issues","Child Care Centers","Child Care Issues","Child Care Provider Licensing","Child Care Provider Referrals","Child Care Providers","Child Care Subsidies","Child Guidance","Child Support Assistance/Enforcement","Children","Children and Youth with Disabilities","Children and Youth with Emotional Disturbance","Children's Clothing","Children's Protective Services","Children's State/Local Health Insurance Programs","Children's/Adolescent Residential Treatment Facilities","Chinese Community","Citizenship Assistance Centers","Citizenship Education","Citizenship and Immigration Services Offices","City/County Parks","City/County Planning Offices","Civic Groups","Civil Service Employees","Civil State Trial Courts","Clergy/Faith Community Personnel","Clothing","Clothing Vouchers","Clothing/Personal Items","Clutterers/Hoarders","Cognitive Behavioral Therapy","Commemorative Events","Commissions, Councils, or Boards","Communicable Disease Control","Community Action/Social Advocacy Groups","Community Adult Schools","Community Clinics","Community Colleges","Community Development Issues","Community Facilities/Centers","Community Improvement","Community Information","Community Planning and Public Works","Companion","Comprehensive Disability Related Employment Programs","Comprehensive Information and Referral","Comprehensive Outpatient Alcoholism Treatment","Comprehensive Outpatient Drug Abuse Treatment","Comprehensive Outpatient Substance Abuse Treatment","Computer User Groups","Computer and Related Technology Classes","Conference/Convention Facilities","Conflict Resolution Training","Congregate Meals/Nutrition Sites","Conjoint Counseling","Conservation","Consumer Assistance","Consumer Complaints","Consumer Law","Consumer Protection Agencies","Consumer Safety Standards","Contraceptive Assistance","Convalescent Care","Counseling Settings","County Correctional Facilities","County Counsel","County Elections Director Offices","County Executive Offices","County Recorder Offices","County Treasurer Offices","Court Ordered Individuals","Courts","Credit Counseling","Crime Prevention","Crime Victim Accompaniment Services","Crime Victim Support","Crisis Intervention","Crisis Intervention/Hotlines","Crisis Shelter","Crisis/Abuse Intervention/Hot","Crohn's Disease","Cultural Heritage Groups","Cultural Transition Facilitation","Cultural/Racial Issues","DEVELOPMENTAL DISABILITIES SERVICES","DRUG ABUSE SERVICES","DUI Offender Programs","Dance Instruction","Dance Performances","Day Camps","Day Care","Day Labor","Day Treatment","Day Treatment for Adults with Developmental Disabilities","Deafness","Death Related Records/Permits","Death and Dying Issues","Defense Representation","Dementia Management","Dental","Dental Care","Dental Care Referrals","Detoxification","Developmental Assessment","Developmental Disabilities","Developmental Disabilities Activity Centers","Developmental Disabilities Day Habilitation Programs","Diabetes","Diabetes Management Clinics","Disabilities Issues","Disability Related Counseling","Disability Related Sports","Disaster Management Organizations","Disaster Preparedness","Disaster Relief","Disease/Disabilities Information","Disease/Disability Information","District Attorney","Diversion","Diversion Programs","Division","Divorce Counseling","Domestic Violence Hotlines","Domestic Violence Issues","Domestic Violence Shelters","Driver Licenses","Driving While Intoxicated","Drop-in Services","Drug Abuse Counseling","Drug Dependency Support Groups","Drug Detoxification","Drug Diversion","Drug-Free Treatment","Dwarfism","EDUCATION SERVICES","EMERGENCY SERVICES","EMPLOYMENT/TRAINING SERVICES","Early Childhood Education","Early Head Start","Early Intervention for Children with Disabilities/Delays","Eating Disorders Treatment","Education","Education/Child Care/Recreation","Education/Information","Elder Abuse Issues","Election Information","Emergency Communications","Emergency Food","Emergency Medical Care","Emergency Room Care","Emergency Shelter","Emergency Shelter Clearinghouses","Employee Fraud Reporting","Employment","Employment Discrimination Assistance","English Language","English as a Second Language","Environment Volunteer Opportunities","Environmental Hazards Information","Environmental Improvement Groups","Environmental Issues","Environmental Protection and Improvement","Equestrian Therapy","Errand Running/Shopping Assistance","Escort","Ex-Offender Reentry Programs","Ex-Offenders","Expectant/New Parent Assistance","Extended Day Care","Eye Care","Eye Examinations","Eye Screening","FAMILY PLANNING SERVICES","FINANCIAL ASSISTANCE SERVICES","Facilities/Community Centers","Families","Families/Friends of Alcoholics Support Groups","Families/Friends of Drug Abusers Support Groups","Families/Friends of GLBT Individuals","Family Counseling","Family Housing/Shared Housing","Family Law","Family Law Courts","Family Planning","Family Support","Family Violence Issues","Farmers Markets","Fathers","Fear of Flying","Federal Government Complaints/Ombudsman Offices","Federated Giving Programs","Feral Cat Management Programs","Field Trips/Travel","Financial Assistance","First Aid Instruction","First Offender DUI Programs","First Time Buyer Home Loans","Flood/Siltation Control","Food","Food Banks/Food Distribution Warehouses","Food Boxes/Food Vouchers","Food Lines","Food Pantries","Food Served/Soup Kitchens","Food Sorting/Packing Volunteer Opportunities","Food Stamps","SNAP","Foster Grandparent Program","Foster Homes for Dependent Children","Foster Parent/Family Recruitment","Fraternal Orders","Friendly Telephoning","Fund Raising","Funding","Furniture","Furniture/Appliances","GED Instruction","Garden Tours","Gay, Lesbian, Bisexual, Transgender Individuals","Gay/Lesbian/Bisexual/Transgender Community Centers","Gay/Lesbian/Bisexual/Transgender Individuals","Gay/Lesbian/Bisexual/Transgender Issues","Genealogical Societies","General Counseling Services","General Legal Aid","General Relief","General Support","Genetic Disease Guidance","Geriatric Counseling","Girls","Glasses/Contact Lenses","Grocery Delivery","Group Counseling","Group Residences for Adults with Disabilities","Group Support","Group/Independent Living","Growth and Adjustment","Guardians ad Litem Volunteer Opportunities","Guardianship/Conservatorship","HANDICAP SERVICES","HEALTH SERVICES","HIV Testing","HOUSING SERVICES","Harbors/Marinas","Hazardous Materials Collection Sites","Head Start","Health","Health Care Referrals","Health Education","Health Facility Complaints","Health Facility Licensing","Health Insurance Information/Counseling","Health Issues","Health Related Temporary Housing","Health Screening/Diagnostic Services","Hearing Impairments","Hearing Loss","Heart Disease","Helplines/Warmlines","Hepatitis","High School Completion/GED","High School Districts","Hispanic/Latino Community","Historic House Museums","Historic Preservation","Historical Societies","Holiday Programs","Home Barrier Evaluation/Removal Services","Home Delivered Meals","Home Health Care","Home Improvement/Accessibility","Home Maintenance and Minor Repair Services","Home Nursing","Home Rehabilitation Loans","Home Rehabilitation Programs","Home Schooling","Homebuyer/Home Purchase Counseling","Homeless Families","Homeless Motel Vouchers","Homeless People","Homeless Shelter","Homelessness Issues","Homeowner Associations","Homework Help Programs","Horticultural Societies","Hospice","Hospice Care","Hospitals","Hostels","Housing","Housing Authorities","Housing Counseling","Housing Discrimination Assistance","Housing Expense Assistance","Housing Issues","Human Resources Personnel","Human Rights Groups","Human Rights Issues","Human Rights/Ombudsman/Advocacy","Human/Social Services Issues","INDIVIDUAL AND FAMILY DEVELOPMENT SERVICES","Identification Cards","Immigration Issues","Immigration/Naturalization","Immigration/Naturalization Legal Services","In Home Assistance","In Home Supportive Services Subsidies","In-Home Supportive","Independent Living Skills Instruction","Individual Counseling","Individual/Group Counseling","Infants/Toddlers","Infertility Diagnosis/Treatment","Information","Information Services","Information and Referral","Inmate Support","Inmate Support Services","Inmate/Ex-Offender","Inmates","Inpatient Alcoholism Treatment Facilities","Inpatient Care","Inpatient Drug Abuse Treatment Facilities","Inpatient Health Facilities","Inpatient Mental Health Facilities","Inpatient Substance Abuse Treatment Facilities","Instructional Materials","Instructional Materials Centers","Intellectual Disabilities","International Human Rights Programs","International Issues","Interpretation/Translation","Investigation/Intervention","Investment Counseling","Jewish Community","Job Counseling/Testing","Job Development","Job Finding Assistance","Job Information","Job Information/Placement/Referral","Job Interview Training","Job Search Techniques","Job Search/Placement","Job Training","Job Training Formats","Juvenile Courts","Juvenile Delinquency Prevent","Juvenile Delinquency Prevention","Juvenile Delinquents","Juvenile Deliquency Prevention","Juvenile Detention Facilities","Kidney Disease","Kinship Caregivers","LEGAL AND CRIMINAL JUSTICE SERVICES","Labor Organizations","Land Conservation","Land Deeds/Titles","Land Records","Landlord/Tenant","Landlord/Tenant Assistance","Landscape Architects","Language Interpretation","Laundry Facilities","Laundry Vouchers","Law Enforcement","Law Enforcement Records/Files","Law Libraries","Lawyer Referral Services","Lead Information","Learning Disabilities","Legal Assistance Modalities","Legal Associations","Legal Counseling","Legal Issues","Legal Representation","Libraries","Library","Literacy","Literacy Programs","Local Bus Services","Long Term Care Ombudsman Programs","Low Cost Meals","Low Income","Low Income/Subsidized Private Rental Housing","Low Income/Subsidized Rental Housing","MENTAL HEALTH SERVICES","Machado-Joseph Disease","Magic Shows","Maintenance","Management Assistance","Marine Conservation","Marine Mammal Protection","Marine Science/Oceanography Clubs/Societies","Marriage Counseling","Marriage and Family Therapist Associations","Material Resources","Maternity Homes","Mayors Office","Mayors Offices","Meal Sites/Home-delivered Mea","Meal Sites/Home-delivered Meal","Meal Sites/Home-delivered Meals","Mediation","Medicaid","Medical Appointments Transportation","Medical Assistance","Medical Associations","Medical Libraries","Medical Public Assistance Programs","Medicare","Medicare Appeals/Complaints","Medicare Enrollment","Meditation","Meeting Space","Men","Mental Health Evaluation","Mental Health Halfway Houses","Mental Health Issues","Mental Health Support Services","Mental Illness/Emotional Disabilities","Mentoring Programs","Mentoring Services Volunteer Opportunities","Metting Space","Migrant Education Programs","Mobile Dental Care","Mobility Aids","Money Management","Mortgage Delinquency and Default Resolution Counseling","Mortuary Services","Mother and Infant Care","Mother/Infant Care","Motor Vehicle Registration","Multiple Birth Children","Multiple Offender DUI Programs","Multiple Sclerosis","Multipurpose Performing Arts Centers","Museums","Music Composers","Music Groups","Music Instruction","Music Performances","Music Recitals","Native American Community","Neighborhood Improvement Groups","Networking/Relationship Building Support","Newborns","Nonprofit/Philanthropic Associations","Nonpublic Special Schools","Nutrition","Nutrition Assessment Services","Nutrition Education","ORGANIZATIONAL SUPPORT SERVICES","Observation/Diagnosis","Occupational","Occupational Health and Safety","Occupational Therapy","Occupational/Professional Associations","Older Adult Social Clubs","Older Adult Volunteers","Older Adult/Aging Issues","Older Adult/Disability Related Supportive Housing","Older Adults","On the Job Training","Open Adoption","Opera Performances","Optometric","Organic Gardening Societies","Out-Of-Home Care","Out-Of-Home Care Placement","Out-of-Home Care","Out-of-Home Care Placement","Outdoor Environmental Education","Outpatient Care","Outpatient Health Facilities","Outpatient Mental Health Facilities","Outreach Programs","Overeating/Food Addiction","Own Recognizance","Palliative Care","Para-Transit","Paratransit Programs","Parent Counseling","Parent Groups","Parent/Family Involvement in Education","Parental Visitation Monitoring","Parenting Education","Parents","Parks/Playground","Parks/Recreation Areas","Parole","Pastoral Counseling","Pathologists","Patriotic Societies","Patriotic Socities","Pediatric Dentistry","Pediatrics","Peer Counseling","People With Disabilities","Performing Arts/Film Personnel","Personal Emergency Response Systems","Physical Activity and Fitness Education/Promotion","Physical Disabilities","Physical Medicine and Rehabilitation","Physical Therapy","Planning Commissions","Planning/Coordinating/Advisory Groups","Planning/Coordintaing/Advisory Groups","Play Therapy","Police/Law Enforcement","Political Associations/Clubs","Political Parties","Port Services","Post Mortem Estate Administration","Poverty Level","Pregnancy Counseling","Pregnancy Testing","Pregnant Teens","Pregnant Women","Prejob Guidance","Prenatal Care","Preschool","Preschool Age Children","Preschools","Prevention","Prevention, Care and Research in Specific Diseases","Prison Ministries","Private Schools","Probate Courts","Probation","Property Tax Agencies","Property Tax Assessment Appeals Boards","Property Tax Collection Agencies","Prosecution Representation","Protective Services for Animals","Psychiatric Case Management","Psychiatric Case management","Psychiatric Day Treatment","Psychiatric Emergency Room Care","Psychiatric Inpatient Units","Psychiatric Medication Monitoring","Psychiatric Resocialization","Psychologist referrals","Public Charities","Public Health","Public Health Information/Inspection/Remediation","Public Health Inspection","Public Health Nursing","Public Housing","Public Inebriate Transportation","Public Lectures/Discussions","Public Libraries","Public Officials Offices","Public Transit","Public Transit Authorities","Pupil Support/Tutoring","RECREATION/LEISURE SERVICES","Re-Entry/Ex-Offender","Recovering Alcoholics","Recovering Drug Abusers","Recreation/Social Activities","Recreation/Social Activity","Recreational Items","Recreational/Leisure/Arts Instruction","Recycling","Refugee Resettlement Services","Regional Occupational Programs","Rehabilitation","Rehabilitation/Occupational","Rehabilitation/Occupational Therapy","Religious Groups/Communities","Religious Service Projects","Relocation","Rental Deposit Assistance","Repairs","Reproductive Issues","Residential Alcoholism Treatment","Residential Alcoholism Treatment Facilities","Residential Camps","Residential Care","Residential Drug Abuse Treatment","Residential Drug Abuse Treatment Facilities","Residential Substance Abuse Treatment","Residential Treatment Facilities","Resocialization/Social Adjustment","Respite Care","Respite/Emergency Caretaker","Resume Preparation Assistance","Retired Military","Retired People","Retirement Benefits","Roommate/Housemate Matching Assistance","Runaway/Youth Shelters","SSI","SSI Appeals/Complaints","Safer Sex Education","Sailing","Scholarships","School Based Teen Parent/Pregnant Teen Programs","School Clothing","School Enrollment and Curriculum","School Readiness Programs","School Supplies","Scouting Programs","Screening/Diagnosis","Screening/Immunization","Section 8 Housing Choice Vouchers","Self-Help","Senior Centers","Senior Companion Program","Senior Out-Of-Home Care Place","Senior and Disabled Housing","Sensory Integration Therapy","Service Animals","Service Clubs","Sexual Assault Counseling","Sexual Assault Hotlines","Sexual Assault Treatment","Sexually Transmitted Disease Screening","Shelter/Refuge","Sheltered Employment","Sheriff","Sister Cities Programs","Skiing","Skilled Nursing Facilities","Small Business Development","Small Business Development and Assi","Small Business Development and Assistance","Small Business Financing","Small Claims Courts","Smoking Cessation","Soccer","Social Clubs/Events","Social Sciences and Humanities Research","Social Security Burial Benefits","Social Security Disability Benefits","Social Security Disability Insurance Appeals/Complaints","Social Security Retirement Benefits","Social Security Survivors Insurance","Social Services for Military Personnel","Soup Kitchens","Speakers","Speakers/Speakers Bureaus","Special Education","Special Education Classes/Centers","Special Events/Entertainment","Special Interest Clubs","Special Libraries","Special Library Collections","Special Needs Job Development","Special Olympics","Speech Therapy","Speech and Language Evaluations","Speech and Language Pathology","Sports/Games/Exercise","Spouse/Domestic Partner Abuse Counseling","Spouse/Domestic Partner Abuse Prevention","Square Dancing Instruction","Staff Training","State Parks","Storytelling","Stroke","Stroke Rehabilitation","Student Disability Services","Student Financial Aid","Studio Space for Artists","Subsidized","Subsidized Home Purchase","Subsidized Housing Administrative Organizations","Substance Abuse Counseling","Substance Abuse Day Treatment","Substance Abuse Education/Prevention","Substance Abuse Hotlines","Substance Abuse Issues","Substance Abuse Referrals","Substance Abuse Services","Substance Abuse Treatment Programs","Support Groups","Sweat Equity Programs","Swimming/Swimming Lessons","System Advocacy","TANF","TRANSPORTATION SERVICES","Tax Preparation Assistance","Team Sports/Leagues","Technical Assistance","Teen Pregnancy Prevention","Teenage Parents","Telecommunication Relay Services","Telephone Assistance","Telephone Crisis Hotline","Telephone Crisis Intervention","Temporary","Temporary Financial Assistance","Tenant Rights Information/Counseling","Terrorism Preparedness Information","Theater Performances","Thrift Shops","Tongan Community","Tools/Equipment","Tourist Information","Trade Associations","Traffic Courts","Training and Employment Programs","Transitional Housing/Shelter","Transportation","Transportation Expense Assistance","Transportation Issues","Transportation Management Associations","Transportation Passes","Travelers Assistance","Tutoring Services","Ulcerative colitis","Utilities","Utility Assistance","Utility Service Payment Assistance","Veteran Compensation and Pension Benefits","Veteran Outpatient Clinics","Veterans","Victims of Accidents Caused by Impaired Drivers","Vocational","Vocational Assessment","Vocational Rehabilitation","Volunteer Assistance","Volunteer Opportunities","Volunteer Recruitment/Placement","Volunteers","Voter Registration Offices","WIC","Weatherization","Weatherization Programs","Weights and Measures","Welfare Rights Assistance","Widowers","Widows","Wildlife Rescue/Relocation","Women","Women's Health Centers","Work Clothing","Work Clothing Donation Programs","Work Tools/Equipment","Y Facilities","Young Adults","Youth","Youth Agricultural Programs","Youth Business Programs","Youth Citizenship Programs","Youth Development","Youth Employment","Youth Enrichment","Youth Enrichment Programs","Youth Job Development","Zoos/Wildlife Parks"]
    cip_keywords.map!{|c| c.downcase} #lowercase all terms in the array

    # retrieve the terminologies
    terms_raw = self.terms
    terms = []
    terms_raw.each do |term|
      terms.push(term[:name])
      term[:aka].each do |aka|
        terms.push(aka)
      end
    end
    terms.map!{|t| t.downcase}

    #retrieve the service_terms
    sterms_raw = self.service_terms
    sterms = []
    sterms_raw.each do |term|
      sterms.push(term[:name])
      term[:sub].each do |sub|
        sterms.push(sub)
      end
    end
    sterms.map!{|s| s.downcase}

    aggregate = cip_keywords.zip(terms).zip(sterms).flatten.compact.uniq
  end

  # location search autocomplete data (all cities of SMC)
  def self.locations
    ['Atherton, CA','Belmont, CA','Brisbane, CA','Burlingame, CA','Colma, CA','Daly City, CA','East Palo Alto, CA','Foster City, CA','Half Moon Bay, CA','Hillsborough, CA','Menlo Park, CA','Millbrae, CA','Pacifica, CA','Portola Valley, CA','Redwood City, CA','San Bruno, CA','San Carlos, CA','San Mateo, CA','South San Francisco, CA','Woodside, CA','Broadmoor, CA','Burlingame Hills, CA','Devonshire, CA','El Granada, CA','Emerald Lake Hills, CA','Highlands-Baywood Park, CA','Kings Mountain, CA','Ladera, CA','La Honda, CA','Loma Mar, CA','Menlo Oaks, CA','Montara, CA','Moss Beach, CA','North Fair Oaks, CA','Palomar Park, CA','Pescadero, CA','Princeton-by-the-Sea, CA','San Gregorio, CA','Sky Londa, CA','West Menlo Park, CA']
  end

  # Looks up whether keyword search term is a terminology term or not.
  # Terminology terms include a definition box with further info on the search results page.
  # @param keyword [String] keyword.
  # @return [String] the search term
  def self.terminology(keyword)
    if keyword.present?

      terms = self.terms

      keyword = keyword.downcase # set keyword to lowercase

      terms.each do |term|
        if keyword == term[:name]
          return term[:name].tr(" ", "_")
        else
          term[:aka].each do |aka|
            if keyword == aka
              return term[:name].tr(" ", "_")
            end
          end
        end
      end

      return nil

    end
  end

  # top level services for when no search results are found
  def self.service_terms
    terms = [
      {:name=>'government assistance',:sub=>['CalFresh/Food Stamps','Health Insurance','WIC',"SFMNP",'Medi-Cal','Medicare'].sort},\
      {:name=>'emergency / crisis intervention',:sub=>['aging and adult services',''].sort},\
      {:name=>"children, teens, youth and families",:sub=>[].sort}
    ]
  end

  # government programs for display on the homepage
  def self.program_terms
    ['CalFresh/Food Stamps','Market Match','Health Insurance','Women, Infants, and Children',"Senior Farmers' Market Nutrition Program",'Medi-Cal','Medicare'].sort
  end

  private

  # @return [Array] list of terms that may be used to display further information
  def self.terms
    terms = [
        {:name=>'wic',:aka=>['women, infants, and children']}, \
        {:name=>'sfmnp',:aka=>["senior farmers' market nutrition program"]}, \
        {:name=>'market match',:aka=>[]}, \
        {:name=>'calfresh',:aka=>['food stamps','snap']}, \
        {:name=>'health care reform',:aka=>['affordable care act','health insurance']} \
      ]
  end

end
