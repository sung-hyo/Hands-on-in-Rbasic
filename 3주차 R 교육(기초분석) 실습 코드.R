# 1. 패키지 설치와 사용방법
#  패키지 설치
### 패키지 설치는 `install.packages("package name")`를 이용해서 설치하고, `()`안에 **문자열**로 패키지 이름을 입력하면 된다. 
install.packages("readxl")
#여러개를 c()함수에 묶어서 사용
install.packages(c("moonBook", "ztable", "epiDisplay","dplyr",
                   "survival", "ggplot2", "gmodels", "GGally")) 

## 패키지 적재하기, 불러오기
### `library(package name)` 또는 `require(package name)`함수를 이용해서 패키지를 적재할 수 있다. 
### `package name::function()` 방식으로 사용하기도 하지만 원활한 작업을 위해서 실행하는 것이 유리한 점이 있다. 
### 유의할 점은 패키지 설치와 다르게 패키지를 적재할때는 패키지 이름에 따옴표를 사용하지 않는다. 문자열로 입력하고자 한다면 `character.only=TRUE` 인자를 추가하면 된다. 

## 기타 패키지 관련 함수
### - `available.packages("package name")`: 패키지가 CRAN에 등록되어 있는지 확인하는 함수
### - `update.packages("package name")`: 패키지를 업데이트하는 함수, 패키지명을 제외하고 `update.packages()`만 실행할 경우 모든 패키지를 업데이트 한다. 
### - `package name::function()` 패키지를 적재하지 않고 특정 패키지의 함수를 사용할 때 이용한다. 

# ==============================================================================
# 2. 데이터 프레임
### 데이터 프레임(data frame)이란 스프레드시트(spreadsheet) 형식의 구조이며 행과 열로 구성된 2차원 형태이다. 
### 열에는 데이터 속성(자료형 등)이 포함되어 있으며, 행에는 인덱스(index)라는 행을 식별하는 속성이 포함되어 있다. 
### 자료를 분석하기 위한 가장 기본적인 자료 구조이다. 
### 데이터 프레임을 만들기 위한 방법은 자료를 직접입력하거나 외부자료를 불러오기를 통해서 만들 수 있다.

# ------------------------------------------------------------------------------
## 데이터 직접입력하기
### R의 가장 기본적인 벡터(vector)을 이용해서 데이터 프레임을 만들 수 있다. 
### 성별을 genders, 악력을 grip_strenth로 변수명을 정하고 값을 저장한다. 
### 이때 성별에 대응하는 악력의 값을 순서대로 입력해야 한다. 
genders <- c(0, 1, 1, 0, 0, 1, 1, 1, 0, 0)
grip_strength <- c(35, 18, 10, 42, 26, 15, 20, 9, 29, 37)
print(genders)
print(grip_strength)

### 벡터로 데이터 프레임 만들기
### 여러개의 백터로 하나의 데이터 프레임으로 만들기 위해서 `data.frame()`함수를 이용한다. 백터로 저장된 변수이름을 콤마로 구분해서 나열하면 된다. 
df <- data.frame(genders, grip_strength)
print(df)

View(df) # 데이터 보기

str(df) # 자료 구조를 `str()`함수를 이용해서 확인한다. 

# ------------------------------------------------------------------------------
## 외부 데이터 이용하기
#### 깃허브에 `예제데이터_2023.csv`, `예제데이터_2023.xlsx` 파일을 다운받아 해당 프로젝트가 위치한 폴더에 저장해서 이용한다. 

### 자료 불러오기(data import, data load)
#### R에서 csv 파일 불러오기
#### 첫번째 행에는 변수의 한글명(라벨)이, 두번째 행에는 영문 변수명,
#### 세번째 행부터 데이터가 저장되어 있다. 각 열은 쉼표로 구분되어 있다.
#### 자료에 변수명(칼럼명)이 있을 경우 `header=TRUE` 인자를 추가하고, 없는 경우 `header=FALSE`를 추가한다. 
df <- read.csv("예제데이터_2023.csv", header = T)
head(df) # 앞에서 5개의 자료 확인

#### 불러올때 첫번째 행을 제외하기 위해 `reqd.csv()` 함수의 인자로 `skip=1`를 추가한다. 
df <- read.csv("예제데이터_2023.csv", header = T, skip = 1)
head(df)

str(df) # 자료구조를 확인

### 엑셀 파일
##### 엑셀로 저장된 자료는 확장자가 `.xls, .xlsx`로 되어 있으며, 자료를 불러오기 위해서 별도의 패키지가 필요하다. 
##### 실습에서는 `readxl` 패키지를 이용한다. 
library(readxl) # readxl 패키지 불러오기

#### 데이터의 첫행은 변수 라벨이므로 제외하기 위해 `skip=1`을 인자로 준다. 첫행이 변수명이고 두번째 행부터 데이터가 입력되어 있다면 생략하면 된다. 
df <- read_xlsx("예제데이터_2023.xlsx", skip=1)
head(df)

str(df)


### 데이터의 행과 열에 접근하는 방법
#### dataframe의 자료에서 변수에 접근하는 방법은 자료명 뒤에 `$`를 붙이고 변수명을 작성하면 된다.
head(df$sex) # 출력하면 너무 많기 때문에 head() 함수를 이용해서 앞에 5개 출력

#### dataframe은 행렬과 유사하고 열번호와 행번호를 이용해서 접근할 수 있다. 
#### 자료명 뒤에 `[]`를 붙여서 이용한다. 
df[1]

df[1:5] # 등차수열 연산자 콜론(:)을 이용해서 1행에서 5행까지의 열을 추출할 수 있다. 

df[c('sex', 'age')] # 변수명을 문자열로 입력해서 추출할 수 있다.

#### `자료명[행번호, 열번호(변수명)]`로 필요한 데이터에 접근할 수 있다. 
df[5, 1]
df[1:5, 1]

#### 대괄호(`[]`)안에 조건을 추가하여 조건에 만족하는 행의 데이터를 추출할 수 있다. 
df[df$sex==1, ] # 성별이 남자인 대상자 추출, 성별의 자료형이 숫자이다. 
df[df$age > 65, ] # 나이가 65세 이상인 대상자 추출

# ------------------------------------------------------------------------------
## 데이터 전처리
### 자료형 변환
df$sex <- as.factor(df$sex) # 성별을 factor 자료형으로 변환
str(df$sex) # 자료구조 확인

df$ho_incm <- as.factor(df$ho_incm)
df$pa_walk <- as.factor(df$pa_walk)
df$subj_health <- as.factor(df$subj_health)

### 변수의 요약값 확인
#### `summary()`함수를 이용하면 데이터에 포함된 모든 변수의 요약값을 확인할 수 있다. 
summary(df)

#### 이산 변수
table(df$sex)
table(df$ho_incm)
table(df$pa_walk)
table(df$subj_health)

#### 주관적 건강수준 변수의 항목 값 9는 모름, 무응답이며, 이값을 결측으로 처리해 준다.
#### 특정값을 `NA`로 변경하면 된다. 
df$subj_health[df$subj_health=='9'] <- NA
table(df$subj_health)

#### factor 자료형에서 처음 선언된 수준(levels)를 기억하기 때문에 이를 제거해주어야 한다. 
df$subj_health <- factor(df$subj_health, levels = c('1','2','3','4','5'))
table(df$subj_health)

#### 연속 변수
hist(df$age)
hist(df$HE_BMI)

### 조작적 정의
#### 당뇨병 구분
df$DM <- ifelse(df$HE_HbA1c >= 6.5, 2,
                ifelse(df$HE_HbA1c >= 5.8, 1, 0))

#### 고혈압 구분
df$HP <- ifelse(df$HE_sbp >= 140 | df$HE_dbp > 90, 2,
                ifelse(df$HE_sbp >= 120 | df$HE_dbp > 80, 1, 0))

#### MDRD 연구 계산식
df$eGFR <- ifelse(df$sex =='1', 
                  175 * (df$HE_crea^-1.154) * (df$age^-0.203),
                  175 * (df$HE_crea^-1.154) * (df$age^-0.203)*0.742)

#### 히스토그램의 구간 개수를 지정해서 확인한다. `hist()`함수에 `breaks=`에 개수를 지정하면 된다. 
hist(df$eGFR, breaks = 100)

#### 값을 추출해서 확인해 본다. 
df[!is.na(df$eGFR) & df$eGFR > 200,]

#### 이상값(극단값) 제거, 200이상
df$eGFR2 <- ifelse(df$eGFR >= 200, NA, df$eGFR)
hist(df$eGFR2, breaks = 100)

#### 분류된 변수의 자료형을 확인하고 변환한다. 
df$DM <- as.factor(df$DM)
df$HP <- as.factor(df$HP)

### 결측값 처리
#### 결측값이 포함된 자료를 이용해서 분석을 실시하게 되면 원하는 결과를 얻지 못하고 잘못된 결과를 도출할 가능성이 있다. 
#### 분석에 사용되는 자료를 정제가 완료된 자료이어야 한다. 


#### 결측값 확인
#### 결측값을 확인하는 방법은 `is.na()`함수를 이용하거나 `complete.cases()` 함수를 이용하면 된다. 
sum(is.na(df))
sum(!is.na(df))
colSums(is.na(df)) # 칼럼별 합계

#### `complete.cases()`는 모든 변수에 대해서 결측이 없는 행인지 확인해 준다.
sum(complete.cases(df))

#### 결측이 없는 케이스만 저장한다. 
df_complete <- df[complete.cases(df), ]
head(df_complete)

#### 변수 추출
#### 분석에 사용하는 변수만 추출하여 저장한다. 
df_finish <- df_complete[, c('sex','age','ho_incm','pa_walk','subj_health',
                             'HE_BMI','DM','HP','eGFR2')]
head(df_finish)

#### `dplyr` 패키지의 `select()` 함수를 이용해서 변수를 추출할 수 있다. 
library(dplyr)
df_finish <- select(df_complete, c('sex', 'age'))
head(df_finish)


#### 추출하는 변수가 많고 제외하는 변수가 적을 경우 변수를 제외하는 것이 효율적일 수도 있다. `-c()`빼기를 붙여 변수를 문자열로 묶어서 사용하면 된다. 
df_finish <- select(df_complete, -c('HE_sbp', 'HE_dbp', 'HE_HbA1c',
                                    'HE_crea','eGFR'))
head(df_finish)

####파이프 연산자 `%>%`를 이용할 수도 있다. 
df_finish <- df_complete %>% select(-c('HE_sbp', 'HE_dbp', 'HE_HbA1c',
                                       'HE_crea','eGFR'))
head(df_finish)


# ==============================================================================
# 기초 분석
# ------------------------------------------------------------------------------
## 교차 분석 
### 교차표를 만드는 것으로 시작한다. 
table(df_finish[, c('sex', 'pa_walk')])
prop.table(table(df_finish[, c('sex', 'pa_walk')]))

### 교차표를 tb1이라는 이름으로 저장하고 `chisq.test()`에 주면 카이제곱검정 결과를 확인할 수 있다. `correct=FALSE`를 인자로 설정해야 한다. 
tb1 <- table(df_finish[, c('sex', 'pa_walk')])
chisq.test(tb1, correct=FALSE)

### `gmodels` 패키지를 이용해서 교차분석을 수행할 수 있으며, 패키지를 이용할 경우 교차표를 별도로 생성하지 않아도 된다. 
library(gmodels)
CrossTable(df_finish$sex, df_finish$pa_walk, chisq = TRUE)

# ------------------------------------------------------------------------------
## 상관분석
### 상관계수가 0이라는 것은 "상관이 없다"로 해석하지만 엄밀히 말해서 선형관계가 아니다로 해석하는것이 올바르다.
cor(df_finish$HE_BMI, df_finish$eGFR2)

### 산점도를 이용해서 시각화해서 확인한다. 
plot(df_finish$HE_BMI, df_finish$eGFR2)

### 한번에 많은 변수로 그래프를 그릴 수 있다. 
pairs(df_finish[, c("age","HE_BMI","eGFR2")])

### 패키지에서 제공하는 유용한 기능을 이용해서 쉽게 확인할 수 있다. 
library("ggplot2")
library("GGally")
ggpairs(df_finish[, c("age","HE_BMI","eGFR2")])

# ------------------------------------------------------------------------------
## 평균비교
### 독립표본 T 검정은 먼저 등분산 검정을 실시한다. 
var.test(df_finish$eGFR2 ~ df_finish$sex) # 등분산검정
# var.test(HE_crea ~ sex, data=df_finish)

### 등분산 검정을 확인하는 F-test는 두 분산의 비율이 1에서 얼마나 벗어 났는가를 이용한다. 
sd_group1 <- sd(df_finish[df_finish$sex == '1', ]$eGFR2)
sd_group2 <- sd(df_finish[df_finish$sex == '2', ]$eGFR2)
cat(sd_group1, sd_group2, sd_group1/sd_group2)

### 't.test()'함수를 이용해서 t-test를 수행한다. 
### 성별에 따라서 GFR은 등분산을 만족하지 못하므로 `var.equal=FALSE`로 설정한다. 
t.test(eGFR2 ~ sex, data=df_finish, paired=FALSE, var.equal = FALSE)

### 또다른 예로 성별에 따른 나이의 평균 차이검정을 실시한다.
var.test(df_finish$age ~ df_finish$sex) # 등분산검정
res_ttest <- t.test(age ~ sex, data=df_finish, paired=FALSE, var.equal = TRUE)
cat("t-value: ", res_ttest$statistic,
    ", p-value: ", res_ttest$p.value)

# ------------------------------------------------------------------------------
## 분산분석
res_anova <- aov(df_finish$eGFR2 ~ df_finish$ho_incm)
res_anova

### `summary()`함수를 이용해서 요약 통계량을 산출
summary(res_anova)

### 사후 분석
#### 분산분석은 집단간 평균 차이 여부를 알려주지만 어떤 차이인지 알려주지 않는다.
#### 이를 확인하기 위한 방법이 사후 분석이며 tukey, duncan, bonferroni 등을 주로 이용한다. 
res_tukey <- TukeyHSD(res_anova)
res_tukey

#### 분석 결과를 저장해서 `plot()`함수로 그래프를 그려본다. 
plot(res_tukey)

# ------------------------------------------------------------------------------
## moomBook 패키지를 이용
library("moonBook")
library("ztable")

### `mytable()` 함수에서 칼럼을 지정하지 않으면 전체 자료에서 빈도를 계산해 주고 결측값을 확인할 수 있다. 
print(mytable(~ sex + HE_BMI, data=df_finish))

### 결측을 제거하기 전의 자료를 이용해서 확인한다. 
print(mytable(~ sex + HE_BMI, data=df))

### 자료의 전체 변수의 기술통계량과 결측 확인한다. 
print(mytable(~ ., data=df_finish))

### 성별을 칼럼(집단)변수로 설정하면 집단간 비교 결과를 추가한 기술통계량 표를 구할 수 있다. 
### `~` 기호 앞에 칼럼 변수를 추가한다. 
### 콘솔 창에 출력되는 결과를 보면 유의확률(p)이 0.05보다 작은 변수는 붉은 색으로 표시된다. 
print(mytable(sex ~ ., data=df_finish))

### `ztable` 패키지를 이용해서 Viewer창에 표시하기 위해서 `type="viewer"`을 추가한다. 
print(ztable(mytable(sex ~ ., data=df_finish)), type="viewer")
