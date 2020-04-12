# Question 1
  # Activate the 'foreign' library
  install.packages("foreign")
  library(foreign)

  # Read the SPSS data
  mySPSSData <- read.spss("salary.sav", to.data.frame = T)
  str(mySPSSData)

# Question 2
  summary(mySPSSData$salbeg)
  summary(mySPSSData$time)
  summary(mySPSSData$age)
  summary(mySPSSData$salnow)
  summary(mySPSSData$edlevel)
  summary(mySPSSData$work)

  # salbeg (initial salary)
  hist(mySPSSData$salbeg, 
       main='Initial Salary Of Employees', 
       xlab='Initial salary', 
       ylab='Frequency',
       border='pink', 
       col='purple')

  qqnorm(mySPSSData$salbeg, col=4); qqline(mySPSSData$salbeg, col=6); 
  boxplot(mySPSSData$salbeg, horizontal=FALSE, main = 'Initial Salary Of Employees', col=c('powderblue'))
  
  # time (working experience)
  hist(mySPSSData$time, 
       main='Working experience in years', 
       xlab='Years', 
       ylab='Frequency',
       border='pink', 
       col='purple')

  qqnorm(mySPSSData$time, col=4); qqline(mySPSSData$time, col=6); 
  boxplot(mySPSSData$time, horizontal=FALSE, main = 'Working experience in years', col=c('powderblue'))
  
  # age
  hist(mySPSSData$age, 
       main='Age of employees', 
       xlab='Age', 
       ylab='Frequency',
       border='pink', 
       col='purple')

  qqnorm(mySPSSData$age, col=4); qqline(mySPSSData$age, col=6); 
  boxplot(mySPSSData$age, horizontal=FALSE, main = 'Age of employees', col=c('powderblue'))
  
  # salnow (current salary)
  hist(mySPSSData$salnow, 
       main='Current salary of employees', 
       xlab='Current salary', 
       ylab='Frequency',
       border='pink', 
       col='purple')

  qqnorm(mySPSSData$salnow, col=4); qqline(mySPSSData$salnow, col=6); 
  boxplot(mySPSSData$salnow, horizontal=FALSE, main = 'Current salary of employees', col=c('powderblue'))
  
  # education level 
  hist(mySPSSData$edlevel, 
       main='Education level', 
       xlab='Level', 
       ylab='Frequency',
       border='pink', 
       col='purple')
  
  qqnorm(mySPSSData$edlevel, col=4); qqline(mySPSSData$edlevel, col=6); 
  boxplot(mySPSSData$edlevel, horizontal=FALSE, main = 'Education', col=c('powderblue'))
  
  # work (employment working hours)
  hist(mySPSSData$work, 
       main='Employement working hours', 
       xlab='Working hours', 
       ylab='Frequency',
       border='pink', 
       col='purple')

  qqnorm(mySPSSData$work, col=4); qqline(mySPSSData$work, col=6); 
  boxplot(mySPSSData$work, horizontal=FALSE, main = 'Employement working hours', col=c('powderblue'))
  
# Question 3
    
    install.packages("nortest")
    library(nortest)
    initialSalary <- mySPSSData$salbeg
    nrow(filter(mySPSSData, is.na(mySPSSData$salbeg)))
    
    # Testing for normality of one quantitative variable (n>50) 
    qqnorm(mySPSSData$salbeg, col=4); qqline(mySPSSData$salbeg, col=6); 
    shapiro.test(initialSalary) # Normality rejected
    lillie.test(initialSalary) # Normality rejected
    # Testing the sufficiency of the mean for central location 
    library(lawstat)
    symmetry.test(initialSalary, option = c("MGG", "CM", "M"), side = c("both", "left", "right"), 
                  boot = TRUE, B = 1000, q = 8/9) # Symmetry rejected
    # Non-parametric hypothesis testing 
    wilcox.test(initialSalary, mu=1000) # Ho hypothesis rejected
    
# Question 4
    
    library(nortest)
    diff <- mySPSSData$salnow - mySPSSData$salbeg
    nrow(filter(mySPSSData, is.na(mySPSSData$salbeg) & is.na(mySPSSData$salnow)))
    
    # Testing for normality of two dependent variables (n>50) 
    qqnorm(diff, col=4); qqline(diff, col=6);
    mean(diff); median(diff) 
    shapiro.test(diff)
    lillie.test(diff)
    # Testing the sufficiency of the mean for central location for the difference
    symmetry.test(diff, option = c("MGG", "CM", "M"), side = c("both", "left", "right"), 
                  boot = TRUE, B = 1000, q = 8/9) # Symmetry rejected
    # Non-parametric hypothesis testing 
    wilcox.test(diff) # Ho hypothesis rejected
    boxplot(diff, horizontal=FALSE, main = 'Salaries differencies', col=c('powderblue'))

# Question 5    
    
    library(nortest)
    nrow(filter(mySPSSData, is.null(mySPSSData$salbeg)))
    
    # Testing for normality of two independent samples 
    salMales <- subset(mySPSSData$salbeg, mySPSSData$sex=='MALES')
    salFemales <- subset(mySPSSData$salbeg, mySPSSData$sex=='FEMALES')
    nM<-length(salMales)
    nF<-length(salFemales)
    allSalaries <- data.frame(salaries=c(salMales, salFemales), sex=factor(rep(1:2, c(nM,nF)), 
                   labels=c('Males','Females')))
    # Testing for normality of each group 
    qqnorm(allSalaries$salaries, col=4); qqline(diff, col=6);
    by(allSalaries$salaries, allSalaries$sex, lillie.test) # Normality rejected
    by(allSalaries$salaries, allSalaries$sex, shapiro.test) # Normality rejected
    # Testing the sufficiency of the mean for central location of both groups (nM, nF > 50)
    install.packages("lawstat")
    library(lawstat)
    symmetry.test(allSalaries$salaries, option = c("MGG", "CM", "M"), side = c("both", "left", "right"), 
                  boot = TRUE, B = 1000, q = 8/9) # Sufficiency rejected
    # Non-parametric hypothesis testing 
    wilcox.test(allSalaries$salaries) # Ho hypothesis rejected
    boxplot(data=allSalaries, salaries~sex ,horizontal=FALSE, xlab='Sex', 
            ylab='Initial salary', main = 'Initial salaries per sex', col=c('powderblue'))
    
# Question 6
    
    # Hypothesis testing for multiple samples
    install.packages("Hmisc")
    library(Hmisc)
    age_cut <- cut2(mySPSSData$age, m=158, g=3, levels.mean = FALSE, oneval = TRUE, onlycuts = FALSE)
    intialSalary <- mySPSSData$salbeg
    age_cut <- factor(age_cut, labels = paste('Age group '))
    allData <- data.frame(intialSalary=intialSalary, age_cut=age_cut)
    
    # Conducting ANOVA
    anova1 <- aov(intialSalary~age_cut, data=allData)
    anova2 <- oneway.test(intialSalary~age_cut, data=allData)
    summary(anova1)

    # Normality of the residuals
    library(nortest)
    lillie.test(anova1$residuals) # Normality rejected
    shapiro.test(anova1$residuals) # Normality rejected
    qqnorm(anova1$residuals, col=4); qqline(anova1$residuals, col=6)
    # Testing the sufficiency of the mean for central location of all age groups (n> 50, n of each group = 158)
    library(lawstat)
    symmetry.test(anova1$residuals, option = c("MGG", "CM", "M"), side = c("both", "left", "right"), 
                  boot = TRUE, B = 1000, q = 8/9) # Sufficiency rejected
    # Non-parametric hypothesis testing 
    kruskal.test(intialSalary~age_cut, data=allData) # Ho hypothesis rejected
    # Multiple comparisons testing using unequal variances
    pairwise.wilcox.test(allData$intialSalary, allData$age_cut)
     
     # Based on the results we identify significant differences using pairwise comparisons: 
     # Age group 1 – Age group 2 
     # Age group 2 - Age group 3
     
     boxplot(data=allData, intialSalary~age_cut ,horizontal=FALSE, xlab='Age category', 
             ylab='Initial salary', main = 'Initial salaries per age category', col=c('powderblue'))
     
# Question 7
     
     # Testing for the association between two categorical variables 
     tab1 <- table(mySPSSData$minority, mySPSSData$sex)
     prop.table(tab1) # Total Table Proportions 
     prop.table(tab1, 1)  # Row Proportions 
     prop.table(tab1, 2) # Column Proportions 
     
     # Implementing Chi squared test and Fisher exact test
     chisq.test(tab1, correct=FALSE, simulate.p.value = TRUE) # Ho hypothesis approved
     fisher.test(tab1) # Ho hypothesis approved
     
   

    

  
  
  
  
  