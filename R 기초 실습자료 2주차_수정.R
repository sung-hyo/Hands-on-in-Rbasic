# 1.표현식(Expression)

## 1) 산술연산자(Arithmetic operator)
### 예제) BMI 계산

weight_kg <- 81.5                      # 몸무게를 저장한 변수를 만든다.
height_cm <- 181.2                     # 키를 저장한 변수를 만든다.
BMI <- weight_kg / (height_cm / 100)^2 # BMI를 계산한다. 
print(BMI)                             # BMI를 출력한다.


BMI <- weight_kg / (height_cm / 100)**2
print(BMI)

BMI_round <- round(BMI, digits=1)
print(BMI_round)


## 2) 비교 연산자(Comparison operator)

### 문자의 비교
str1 <- "a"
str2 <- "A"
comparison_result <- str1 > str2
print(comparison_result)

value1 <- 1
value2 <- "a"
comparison_result <- (value1 < value2)
print(comparison_result)

value1 <- 1
value2 <- FALSE
comparison_result <- (value1 < value2)
print(comparison_result)

value1 <- 1
value2 <- TRUE
comparison_result <- (value1 == value2)
print(comparison_result)

## 3) 논리 연산자(Logical operator)

ans1 <- TRUE & FALSE
print(ans1)

ans2 <- TRUE | FALSE
print(ans2)

ans3 <- !FALSE
print(ans3)

SBP <- 115
DBP <- 81
ans <- (SBP < 120 & DBP < 80)
print(ans)

# ans <- (120 <= SBP & SBP < 130) | (80 <= DBP & DBP < 90)
ans <- (SBP >= 120 & SBP < 130) | (DBP >= 80 & DBP < 90)
print(ans)

## 4) 기타 연산자(Miscellaneous operator)
### 콜론(colon) 연산자
seq_x <- 1:10
print(seq_x)
typeof(seq_x)

seq_x1 <- seq(1, 10, 1) # seq(from=2, to=10, by=1)
print(seq_x1)
typeof(seq_x1)

#동일한 벡터인지 확인
# 인덱스가 일치하는 벡터의 요소값이 일치하는지를 반환해준다. 
seq_x == seq_x1


### `%in%` 연산자
seq_x %in% 9
seq_x1 %in% 9

seq_x[seq_x %in% 9]

seq_x %in% c(1,2)


### 벡터, 행렬 등의 산술 연산자 

vec1 <- c(1,2,3,4)
vec2 <- c(5,6,7,8)
vec_inner <- vec1 %*%vec2
cat("벡터의 내적은:", vec_inner) 
sum(vec1 * vec2) # 다음 연산과 동일하다. 


### 예제) 벡터의 크기(길이)
vec1 <- c(1,2,3,4)
vec1_inner <- vec1 %*% vec1
vec1_length <- sqrt(vec1_inner)
cat("벡터의 크기:", vec1_length) 

matrix1 <- matrix(c(1,2,3,4), nrow = 2, ncol = 2)
matrix1
matrix2 <- matrix(c(5,6,7,8), nrow = 2, ncol = 2)
matrix2
mat_multiple <- matrix1 %*% matrix2
print(mat_multiple)

# 조건문
## if 문
SBP <- 115
DBP <- 81

if (SBP < 120 & DBP < 80){
  print("정상")
}


if (SBP < 120 & DBP < 80){
  print("정상")
} else {
  print("이상")
}


## ifelse 문
ifelse(SBP < 120 & DBP < 80, "정상", "이상")

ifelse(SBP < 120 & DBP < 80, "정상", )

### 예제) 성별로 악력 기준 구분하기

genders <- c(0, 1, 1, 0, 0, 1, 1, 1, 0, 0)
grip_strength <- c(35, 18, 10, 42, 26, 15, 20, 9, 29, 37)

ifelse(genders == 1,
       ifelse(grip_strength > 18, 0, 1),
       ifelse(grip_strength > 28, 0, 1))

# 반복문
## if 문을 사용한 예
### step1
for (i in genders){
  print(i)
}

### step2
for (i in 1:length(genders)){
  print(i)
}

### step3
for (i in 1:length(genders)){
  print(grip_strength[i])
}

### step4
for (i in 1:length(genders)){
  if (genders[i] == 0){
    if (grip_strength[i] < 28){
      print(1)
    } else {
      print(0)
    }
  } else {
    if (grip_strength[i] < 18){
      print(1)
    } else {
      print(0)
    }
  }
}


# 자료 불러오기(data import, data load)
### 패키지 설치
install.packages("readxl")


### 패키지 적재(built-in)하기

#### 예제 자료 불러오기
df <- read.csv("예제데이터_국건영.csv", header = T)
head(df)
head(df) # 앞에서 5개의 자료 확인
View(df)

df <- read.csv("예제데이터_국건영.csv", skip = 1)
head(df)
str(df) # 자료구조를 확인
View(df)


library(readxl)

df <- read_xlsx("예제데이터_국건영.xlsx", skip=1)
head(df)
str(df)

df$sex

dim(df) # df 자료의 차원을 확인

df[1]

sum(df$sex) # 에러 발생하지 않음, 합계 계산됨

df$sex <- as.factor(df$sex) # 성별을 factor 자료형으로 변환
str(df$sex) # 자료구조 확인
sum(df$sex) # 에러 발생

table(df$sex) # 성별의 빈도 확인

## 당뇨병 구분
df$DM <- ifelse(df$HE_HbA1c >= 6.5, 2,
                ifelse(df$HE_HbA1c >= 5.8, 1, 0))

## 고혈압 구분
df$HP <- ifelse(df$HE_sbp >= 140 | df$HE_dbp > 90, 2,
                ifelse(df$HE_sbp >= 120 | df$HE_dbp > 80, 1, 0))

## GFR MDRD 계산식
df$eGFR <- ifelse(df$sex =='1', 
                  175 * (df$HE_crea^-1.154) * (df$age^-0.203),
                  175 * (df$HE_crea^-1.154) * (df$age^-0.203)*0.742)

## 통계에서 주로 이용한 함수
min(df$age) # 최소값
max(df$age) # 최대값
median(df$age) # 중앙값
quantile(df$age) # 분위수
sum(df$age) # 합계
mean(df$age) # 평균
sd(df$age) # 표준 편차
sqrt(var(df$age)) # 표준 편차는 분산의 제곱근

### [추가] moomBook 패키지를 이용
install.packages("moonBook")
install.packages("ztable")

library("moonBook")
library("ztable")

print(mytable(~ sex + age, data=df))

print(mytable(~ ., data=df))

print(mytable(sex ~ ., data=df))

print(ztable(mytable(sex ~ ., data=df)), type="viewer")

