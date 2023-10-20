# 1. 로지스틱 회귀분석

# 로지스틱 회귀모형은 반응변수(종속변수)가 이항분포를 따르는 경우에 사용되는 회귀분석 방법이다. 
# 로지스틱 회귀모형의 종속 변수는 성공(1)과 실패(0) 두 가지 범주를 가지는 변수이다.
# 이외에 두 가지 이상의 범주를 가지는 경우에는 다항 로지스틱 회귀모형을 이용한다. 

# 분석 준비
# 예제 데이터는 Framingham Heart Study dataset을 이용하고, 아래의 kaggle에서 다운로드 해서 이용한다. 
# [https://www.kaggle.com/datasets/aasheesh200/framingham-heart-study-dataset/](https://www.kaggle.com/datasets/aasheesh200/framingham-heart-study-dataset/)

df <- read.csv("framingham.csv")
head(df) # 데이터 확인

# `df`로 저장된 자료의 구조를 확인한다. 
str(df)

# 변수 척도 변환
# 불러들인 자료에서 변수의 자료형과 코드북에 정의된 자료형이 다르므로 이를 변환해 준다. 
df$male <- as.factor(df$male)
df$education <- as.factor(df$education)
df$currentSmoker <- as.factor(df$currentSmoker)
df$BPMeds <- as.factor(df$BPMeds)
df$prevalentStroke <- as.factor(df$prevalentStroke)
df$prevalentHyp <- as.factor(df$prevalentHyp)
df$diabetes <- as.factor(df$diabetes)
df$TenYearCHD <- as.factor(df$TenYearCHD)

# 변환 후 자료 구조를 한번 더 확인한다. 
str(df)

# 로지스틱 회귀 분석
# 로지스틱 회귀 분석은 일반선형모형(generalized linear model)의 한 종류로 R의 내장 함수 `glm()`을 이용해서 수행한다.
# `glm()`에서 family는 반응(종속) 변수의 분포에 따라 정규분포인 경우 gaussian, 이항분포인 경우 binomial, 포아송분포인 경우 poisson을 사용한다. 
# 로지스틱 회귀 분석의 반응 변수는 이항분포를 가정하므로 `family`의 값을 `binomial()`로 지정한다. 
# R을 이용한 모형 분석에서 `formula`라는 인자값을 입력하는 방법을 알아야 한다. 
# 기본적인 `formula`는 반응(종속) 변수를 앞에 쓰고 설명(독립) 변수를 뒤에 쓰며, 반응 변수와 설명 변수의 구분을 `~`(물결) 기호로 구분한다. 
# 또한 여러개의 설명 변수를 이용하는 다중(다변수) 분석에서 설명 변수를 `+`(더하기) 기호를 이용해서 추가한다.
# 자료에 포함된 모든 변수를 설명 변수로 이용하고자 하는 경우 `.`(점)을 이용하면 된다. 
# 관상동맥질환(CHD) 여부에 나이가 미치는 영향을 알아보기 위해 `TenYearCHD ~ age` 모형식을 이용해서 단순 로지스틱 회귀 분석을 실시한다. 
# family = binomial()의 초기값은 family = binomial(link="logit")
result_logistic0 = glm(TenYearCHD ~ age, data = df, family = binomial())
summary(result_logistic0)


# 변수를 추가한 다중 로지스틱 회귀 분석을 실시한다. 
result_logistic1 = glm(TenYearCHD ~ age + male + education + currentSmoker,
                       data = df, family = binomial())
summary(result_logistic1)

# 주의할 점중 하나는 각 모형식(추가되는 변수)에 따라서 결측치의 개수가 다르다는 것이다.
# 이는 정제되지 않은 자료를 이용할 경우 발생하게 된다.
# 모형식에 추가되는 변수에 따라 해당 변수의 결측이 존재하는 경우 결측을 제거하고 분석이 실행된다. 
# 분석을 위해서는 결측이 없는 정제된 자료를 이용하거나 추가적인 설정(결측치 보간 등)이 필요하다. 

# 결측값 제거
# 결측을 제거하기전에 분석에 필요한 변수를 추출한 데이터를 만들고 결측치를 제거하는 것이 유용하다. 
# 여기에서는 `complete.cases()`함수를 이용하고 그외에 `is.na()`,`na.omit()`등을 이용해서 처리할 수 있다.
# `complete.cases()`는 전체 자료에서 행별로 결측이 없는 케이스에 대해서 논리값으로 반환해주는 함수이다. 

df_complete <- df[complete.cases(df),] #행열 인덱스 [] 를 이용한다. 
rownames(df_complete) <- NULL # 행의 인덱스 번호(이름)을 유지하기 때문에 이를 제거하면 인덱스 번호가 초기화 된다. 


# 모형의 변수 선택
# 통계적인 변수 선택 방법은 **단계적 방법**과 **위계적 방법**으로 나눈다. 
# **단계적 방법**은 전진(forward), 후진(backward), 단계적(stepwise) 변수 선택 방법이 있으며 그외 여러 방법이 존재한다. 
# 이러한 방법은 학문, 지식에 기반한 변수 선택방법이 아닌 자료를 이용하는 방법으로 변수와 변수 간의 관계를 분석해서 판단하기 때문에 연구자가가 확인하고자 하는 주요 변수와 조절변수(통제 변수, 공변량)가 제외 될 수 있다.
# **위계적 방법**은 연구자의 경험과 지식에 근거하여 변수를 선택하는 방법이다. 
# 변수를 개별 또는 그룹 단위로 묶어서 변수들을 추가하는 방법이다. 
# 사전 지식에 근거하여 변수를 선택하기 때문에 충분한 검토가 필요로 한다.
# 단계적 방법
# 변수 선택 방법을 `step()`함수를 이용하고 direction`에 `"forward", "backward", "both"`를 지정하면 된다.
# 자료에 포함된 모든 변수를 이용하기 위해 모형식을 `TenYearCHD ~ .`으로 주고 분석을 실행한다. 
result_logistic1 = glm(TenYearCHD ~ . , data = df_complete, family = binomial())
result_backward <- step(result_logistic1, direction = "backward")

# 최종 선택된 변수의 모형식을 출력한다. 
formula(result_backward)

# 위계적 방법
# 인구사회학적 변수를 추가한 분석을 실시한다. 
result_logistic3 = glm(TenYearCHD ~ male + age + education + currentSmoker +
                         cigsPerDay, data = df_complete, family = binomial())
summary(result_logistic3) # 분석결과를 요약해서 출력

# 질환과거력 변수를 추가한 분석을 실시한다. 
result_logistic4 = glm(TenYearCHD ~ male + age + education + currentSmoker +
                         cigsPerDay + prevalentHyp + prevalentHyp + diabetes, data = df_complete, family = binomial())
summary(result_logistic4)

# 혈액검사 등 검사결과 변수를 추가한 분석을 실시한다. 
result_logistic5 = glm(TenYearCHD ~ male + age + education + currentSmoker +
                         cigsPerDay + prevalentHyp + prevalentHyp + diabetes +
                         totChol + sysBP + diaBP + BMI + heartRate + glucose,
                       data = df_complete, family = binomial())
summary(result_logistic5)

# 성능 비교
# 로지스틱 회귀 모형은 일반적으로 분류모형이기 때문에 회귀분석에서 이용하는 성능 평가 방법($R^2$ 등)을 이용하지 않는다. 
# 오차 행렬
# - True Positive(TP) : 실제 Positive인 값을 Positive라고 예측한 빈도 수
# - False Positive(FP) : 실제 Negative인 값을 Positive라고 예측한 빈도 수, 통계학에서 제1종 오류($\apha$), 귀무가설이 참인데 기각하는 오류
# - False Negative(FN) : 실제 Positive인 값을 라고 예측한 빈도 수, 통계학에서 제2종 오류($\beat$), 귀무가설이 거짓인데 채택하는 오류
# - True Negative(TN) : 실제 Negative인 값을 Negative라고 예측한 빈도 수
# 분류 모형에 대해서 평가하기 위한 지표는 Accuracy(정확도), Precision(정밀도), Recall(재현율), F1 score가 주로 사용된다. 
# 1. Accuracy(정확도)
# - 실재 클래스를 예측한 클래스가 동일하게 예측한 정도이다. 
# - 오차행렬을 이용하여 아래의 식으로 계산할 수 있다. 
# - 정확도는 정확히 예측한 수를 전체 샘플 수로 나눈 값이다. 
# - 정확도는 직관적으로 모델의 성능을 나타내는 평가 지표이지만, 불균형 데이터셋에서는 보완이 필요한 지표이다. 
# - 불균형 데이터셋이란 두가지 클래스를 가지는 자료에서 하나의 클래스가 다른 하나의 클래스에 비해 월등히 많은 자료를 말한다. 이러한 경우 모형은 많은 클래스를 가지는 값에 대해서 잘 예측하지만 다른 값은 잘 예측하지 못하여 정확도는 높지만 성능은 낮게 된다.  
#   2. Precision(정밀도)
# - precision 또는 positive predictive value(PPV, 양성예측값)이라고 한다. 
# - positive라고 예측된 것 중에서 실재로 positive 인지를 측정한 값이다. 
# - 정밀도는 False Positive를 줄이는 것을 목표로 할때 사용하는 지표이다.
#   3. Recall(재현율)
# - 통계학에서는 sensitivity(민감도)라고 하면, 때로는 hit rate(적중률), or true positive rate(TPR)이라고 한다.
# - 전체 Positive 중에서 얼마나 많은 Positive로 예측하는 측정하는 지표 이다. 
# - 재현율은 모든 Positive를 예측해야 할 때 지표로 사용된다. 즉 False Negativie를 피하는 것을 목표로 할 때 사용된다. 
# - 예측된 결과를 모두 Positive 클래스로 예측한다면 재현율은 1이 된다. 그러나 False Positive를 많이 분류하게 되어 정밀도가 매우 낮아지게 된다. 재현율과 정밀도는 서로 반비례 관계에 있다. 
#   4. F1 score
# - 정밀도와 재현율은 중요한 측정 지표이다. 이를 보완하는 것이 F1 score이다. 
# - 정밀도와 재현율의 조화 평균으로 계산된다.
# - 정밀도와 재현율을 같이 고려하므로 불균형 데이터셋에서 정확도보다 더 나은 지표가 될 수 있다. 

# Confusion matrix 구하기 
# `caret` 패키기에서 제공하는 `confusionMatrix()` 함수를 이용해서 구한다. 

#install.packages("caret")
library(caret)

# `confusionMatrix(예측값, 실제값)` 형태로 작성하면 된다. 
model4_pred <- predict(result_logistic4, type = "response")
model4_pred_c <- as.factor(ifelse(model4_pred > 0.5 , 1 , 0))
confusionMatrix(model4_pred_c, df_complete$TenYearCHD, positive = '1')

model5_pred <- predict(result_logistic5, type = "response")
model5_pred_c <- as.factor(ifelse(model5_pred > 0.5 , 1 , 0))
confusionMatrix(model5_pred_c, df_complete$TenYearCHD, positive = '1')

# ROC curve를 이용한 AUC 계산
library(pROC)

# 예측값을 구한다. 
model4_pred <- predict(result_logistic4, type = "response")
model5_pred <- predict(result_logistic5, type = "response")

# ROC를 구한다. 
roc_model4 <- roc(df_complete$TenYearCHD ~ model4_pred)
roc_model5 <- roc(df_complete$TenYearCHD ~ model5_pred)

# ROC curve를 그린다. 
plot(roc_model4, print.auc=TRUE, max.auc.polygon=TRUE)

# `Epi` 패키지의 `ROC()`함수를 이용하는 방법은 아래의 코드와 같다. 
#install.packages("Epi")
library(Epi)

ROC(form=formula(result_logistic4), data=df_complete, plot="ROC")

# 두 가지 분석결과의 ROC를 겹쳐 그릴 수 있다. 
plot(roc_model4)
plot(roc_model5, add=T, lty=2, col="red")

# 두 가지 모형의 AUC 값의 차이를 비교할 수 있다.
roc.test(roc_model4, roc_model5)

# 로지스틱 회귀 분석의 결과 정리
# 로지스틱 회귀 분석 결과에서 각 변수에 대한 Odds Ratio를 주요 결과로 제시한다. 
summary(result_logistic5)

# Odds Ratio를 추출하기 위해서 추정된 계수를 지수변환하면 된다. 
exp(coef(result_logistic5)) # odds ratio
exp(confint(result_logistic5)) # odds ratio의 신뢰구간
summary(result_logistic5)$coefficient[,4] # 유의확률 p-value

# 패키지를 이용하면 편리하면 유용하다. 
library(moonBook)
library(ztable) # 뷰어창에 출력 시각화
extractOR(result_logistic5)

print(ztable(extractOR(result_logistic5)), type='viewer')

# 결과의 시각화 표현
library(ggplot2)
# 로지스틱 회귀 분석 결과에서 Odds ratio 추출
result_odds <- extractOR(result_logistic5)

# plot 그리기
ggplot(result_odds, aes(x = OR, y = rownames(result_odds))) +
  geom_vline(xintercept = 1, linetype = "dashed") +
  geom_errorbarh(aes(xmin = lcl, xmax = ucl), height = 0.2) +
  geom_point(size = 3) +
  ggtitle("Odds ration for hematoma") +
  xlab("Odds ratio") +
  ylab("Predictors")

# `moonbook` 패키지에서 오즈비를 시각화해서 직관적으로 표현하기 위해 `ORplot()` 함수를 제공한다. 
# `ORplot()`를 이용해서 세가지 모양의 그래프를 그릴 수 있으며(type=1,2,3), show.OR(default 값은 TRUE)와 show.CI(default 값은 FALSE)를 설정할 수 있다. 
ORplot(result_logistic5, type=1, main="Plot for Odds ratios of Model")


#===============================================================================
# 2. 생존분석(survival analysis)
# 생존 분석은 어떠한 현상이 발생하기까지에 걸리는 시간에 대해 분석하는 방법이다. 
# 의학연구에서는 Kaplan-Meier 생존 분석으로 이용해서 생존함수를 추정하고 사건의 발생률을 계산한다. 
# 그리고 Cox proportional hazard model(Cox 비례위험모형)을 이용해서 사건의 발생에 미치는 위험 인자를 확인한다. 

#install.packages("survival")
#install.packages("survminer")
library(survival)
library(survminer)

# 분석 준비
data(retinopathy, package="survival")
head(retinopathy)

str(retinopathy)

# 생존 분석을 위해서는 시간과 사건여부를 가지고 생존 객체를 만들어 주어야 한다. 
# 생존 객체는  `Surv()`함수를 이용해서 만든다. 
# `Surv(시간, 상태)`의 형태로 작성한다. 
Surv(retinopathy$futime, retinopathy$status == 1)[1:10] # 앞에서 10개를 출력

# Kaplan-Meier curve
# 생존 분석을 이용하는 연구에서는 Kaplan-Meier curve를 제시한다. 
# `survfit()`함수에 생존 객체를 넣어주면 되고 `~` 다음에 1을 주면 전체에 대해서 분석을 수행한다. 
km1 <- survfit(Surv(futime, status) ~ 1, data = retinopathy)
km1

# `plot()`함수를 이용해서 그래프를 그린다. 
plot(km1)

# `survminer` 패키지의 `ggsurvplot()` 함수를 이용해서 그래프를 그린다. 
km_plt0 <- ggsurvplot(km1) # fun의 기본값은 'pct'
print(km_plt0$plot)


# `fun`의 인자를 `"cumhaz"` 값으로 주면 cumulative hazard 그래프를 그려준다.
# https://www.rdocumentation.org/packages/survminer/versions/0.1.1/topics/ggsurvplot
km_plt1 <- ggsurvplot(km1, fun='cumhaz')
print(km_plt1$plot)

# Treatment group(trt) 별로 사건이 발생한 시점의 시간과 생존율을 구할 수 있다. 
# `~` 다음에 trt 변수를 작성하면 된다. 
# `ggsurvplot()`의 매개변수를 이용해서 시각화할 수 있다. 
km2 <- survfit(Surv(futime, status) ~ trt, data = retinopathy)
km_plt2 <- ggsurvplot(km2,
                      title="KM Curve  by Treatment",
                      conf.int = TRUE, # 신뢰구간 표현 여부
                      risk.table = TRUE, # 테이블 표시 여부
                      risk.table.height = 0.4, # 테이블 높이 설정
                      ggtheme = theme_bw(), # 데이터 테마 설정
                      font.x = c(10), # x축 제목 크기 설정
                      font.y = c(10), # y축 제목 크기 설정
                      font.tickslab = c(10), # 축 값 크기 설정
                      surv.median.line = "hv", # 50% 생존지점 표시, h는 수평, v는 수직을 의미
                      break.time.by = 5,
                      xlim = c(0,70),
                      pval = F # Log rank test의 p-value의 표시여부
)
print(km_plt2$plot)

# 두 그룹(treatment group) 간의 생존율의 차이에 대한 Log rank test 결과를 추가할 수 있다. 
km_plt3 <- ggsurvplot(km2,
                      title="KM Curve  by Treatment",
                      conf.int = TRUE, # 신뢰구간 표현 여부
                      legend.title="Treatment",
                      legend.labs =c("control eye", "treated eye"),
                      risk.table = TRUE, # 테이블 표시 여부
                      risk.table.height = 0.4, # 테이블 높이 설정
                      ggtheme = theme_bw(), # 데이터 테마 설정
                      font.x = c(10), # x축 제목 크기 설정
                      font.y = c(10), # y축 제목 크기 설정
                      font.tickslab = c(10), # 축 값 크기 설정
                      surv.median.line = "hv", # 50% 생존지점 표시, h는 수평, v는 수직을 의미
                      break.time.by = 5,
                      #xlim = c(0,70),
                      pval = T # Log rank test의 p-value의 표시여부
)
print(km_plt3$plot)

# 그래프에 주석(annotate)을 추가하기 위해서 아래와 같이 작성한다. 
km_plt4 <- ggsurvplot(km2,
                      title="KM Curve  by Treatment",
                      xlab="Time(Days)",
                      legend.title="Treatment",
                      legend.labs =c("control eye", "treated eye"),
                      conf.int = TRUE, # 신뢰구간 표현 여부
                      ggtheme = theme_bw() # 데이터 테마 설정
)
km_plt4$plot <- km_plt4$plot + annotate("text",      # 그래프에 텍스트 추가
                                        x=20,          # 텍스트 x 축 위치 
                                        y=0.25,        # 텍스트 y 축 위치 
                                        label="p-value for log rank test: 0.001"
                                        )
print(km_plt4$plot)

# 특정 시점의 생존율은 `summary()` 함수의 `time=`의 인자에 값을 주면 구할 수 있다. 
summary(km1,time=60)

# 여러 시점의 생존율은 다음과 같이 구한다. 
summary(km1,time=c(30, 60)) 

# Cox Proportional Hazard Model
# Kaplan-Meier와 Log-Rank Test 방법은 시간(Time)과 사건(Event)만을 고려하여 생존율을 추정하는 가장 단순한 방법이다.  
# Cox Proportional Hazard Model(이하 Cox 모형)은 사건 발생에 영향을 줄 수 있는 변수들의 특징을 반영한 모델을 구축할 수 있다. 
# 비례위험은 시간에 상관없이 어떤 변수의 위험비(hazard ratio, HR)는 항상 일정하다는 모형의 기본가정이다(비례위험가정). 위험비는 연구기간 내 일정하기 유지되어야 한다는 가정이다. 
cox_fit <- coxph(Surv(futime, status==1) ~ trt 
                 , data = retinopathy)
summary(cox_fit)

# 분석 결과를 시각화한다. 
cox_plt <- ggforest(cox_fit, data=retinopathy)
plot(cox_plt)

# `moonbook` 패키지으 `HRplot()` 이용해서 시각화 할 수 있다. 
HRplot(cox_fit,show.CI=TRUE,pch=2,sig=0.05)


# finalfit
# 단순 분석과 다중 분석을 `finalfit` 패키지를 이용해서 간단히 수행할 수 있다. 
library(finalfit)
dependent_model <- 'Surv(futime, status == 1)'
explanatory <- c('trt', 'age', 'laser', 'type', 'risk')
result_cox <- retinopathy %>% 
  finalfit(dependent_model, explanatory, add_dependent_label = FALSE)
print(result_cox)

# viewer 창에 결과를 표현
print(ztable(result_cox), type='viewer')
