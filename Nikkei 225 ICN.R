# IMPORTATION, LOG-RENDEMENTS ET TEST ADF

install.packages("quantmod")
install.packages("urca")
install.packages("FinTS")
install.packages("forecast")


library(quantmod)
library(urca)
library(FinTS)
library(forecast)

# Récupération des données depuis Yahoo Finance (Fréquence mensuelle)
# Période choisie : Janvier 2012 à Décembre 2023 
getSymbols("^N225", src = "yahoo", periodicity = "monthly", from = "2012-01-01", to = "2023-12-31")
getSymbols("ICLN", src = "yahoo", periodicity = "monthly", from = "2012-01-01", to = "2023-12-31")

# Extraction exclusive des prix de clôture ajustés 
Prix_N225 <- Ad(N225)
Prix_ICLN <- Ad(ICLN)

# Nettoyage des éventuelles valeurs manquantes 
Prix_N225 <- na.omit(Prix_N225)
Prix_ICLN <- na.omit(Prix_ICLN)

# Construction des séries de log-rendements continus
# diff(log(x)) calcule le log-rendement. On supprime la 1ère valeur qui devient NA.
Rendement_N225 <- na.omit(diff(log(Prix_N225)))
Rendement_ICLN <- na.omit(diff(log(Prix_ICLN)))

# visualisation graphique afin de déterminer la stationnarité visuellement
par(mfrow=c(2,1))
plot(Rendement_N225, main="Log-Rendements mensuels - Nikkei 225", col="blue", ylab="Rendement")
plot(Rendement_ICLN, main="Log-Rendements mensuels - ICLN ETF", col="darkgreen", ylab="Rendement")
par(mfrow=c(1,1)) 

# Tests de racine unitaire (Dickey-Fuller Augmenté)
# Pour les rendements, on choisit le modèle sans constante ni tendance (type='none')
# Le nombre de retards est optimisé via le critère AIC

cat("\n--- Test ADF sur les log-rendements du NIKKEI 225 ---\n")
TestADF_N225 <- ur.df(Rendement_N225, type = "none", selectlags = "AIC")
summary(TestADF_N225)

cat("\n--- Test ADF sur les log-rendements de l'ETF ICLN ---\n")
TestADF_ICLN <- ur.df(Rendement_ICLN, type = "none", selectlags = "AIC")
summary(TestADF_ICLN)

# Test ARCH 

cat("\n--- Test ARCH sur les log-rendements du NIKKEI 225 ---\n")
ArchTest_N225_lag1 <- ArchTest(Rendement_N225, lags = 1)
print(ArchTest_N225_lag1)

ArchTest_N225_lag3 <- ArchTest(Rendement_N225, lags = 3)
print(ArchTest_N225_lag3)

cat("\n--- Test ARCH sur les log-rendements de l'ETF ICLN ---\n")
ArchTest_ICLN_lag1 <- ArchTest(Rendement_ICLN, lags = 1)
print(ArchTest_ICLN_lag1)

ArchTest_ICLN_lag3 <- ArchTest(Rendement_ICLN, lags = 3)
print(ArchTest_ICLN_lag3)


cat("\n================ NIKKEI 225 ================\n")


# Identification (Graphiques)
par(mfrow=c(1,2))
acf(Rendement_N225, main="ACF - Nikkei 225", lag.max=20)
pacf(Rendement_N225, main="PACF - Nikkei 225", lag.max=20)
par(mfrow=c(1,1))

# Estimation Avec l'utilisation de la fonction auto.arima
# Ici on précise maniellement que d=0 car on le sait d'avance via notre étude.
Modele_N225 <- auto.arima(Rendement_N225, d=0, ic="aic", trace=FALSE)
cat("\nModèle retenu pour le Nikkei 225 :\n")
print(summary(Modele_N225))

# Diagnostic (Test de Ljung-Box sur les résidus)
cat("\nTest de Ljung-Box sur les résidus du modèle N225 :\n")
Test_Box_N225 <- Box.test(Modele_N225$residuals, lag=12, type="Ljung-Box")
print(Test_Box_N225)

#  Prévision à 6 pas (h = 6)
Prevision_N225 <- forecast(Modele_N225, h=6)
plot(Prevision_N225, main="Prévisions à 6 mois - Rendements Nikkei 225", col="blue", ylab="Rendement")

cat("\n================ ETF ICLN ================\n")

# Identification
par(mfrow=c(1,2))
acf(Rendement_ICLN, main="ACF - ICLN", lag.max=20)
pacf(Rendement_ICLN, main="PACF - ICLN", lag.max=20)
par(mfrow=c(1,1))

# Estimation
Modele_ICLN <- auto.arima(Rendement_ICLN, d=0, ic="aic", trace=FALSE)
cat("\nModèle retenu pour l'ETF ICLN :\n")
print(summary(Modele_ICLN))

#  Diagnostic
cat("\nTest de Ljung-Box sur les résidus du modèle ICLN :\n")
Test_Box_ICLN <- Box.test(Modele_ICLN$residuals, lag=12, type="Ljung-Box")
print(Test_Box_ICLN)

#  Prévision à 6 pas (h = 6)
Prevision_ICLN <- forecast(Modele_ICLN, h=6)
plot(Prevision_ICLN, main="Prévisions à 6 mois - Rendements ETF ICLN", col="darkgreen", ylab="Rendement")
