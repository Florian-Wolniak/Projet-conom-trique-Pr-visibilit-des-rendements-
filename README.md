# Projet économétrique sur l'Efficience Informationnelle et la Marche aléatoire de deux indices Boursiers : ICN et Nikkei 225

## Présentation
Dans ce projet, nous nous intéresserons a l'hypothèse d'Efficience Informationnelle des marchés financiers dans sa forme faible (Fama, 1965), en se basant sur deux indices boursiers. Ce choix d'indice est intéressant de par leurs spécificités idiosyncratiques, le Nikkei pour son histoire macroéconomique et sa forte influence culturelle dans l'économie. Ensuite l'ICN, représentant les marchés énergétiques et donc une taxation particulière et une approche centré sur le bien-être commun. 

## Méthodologie et Données 
Nous nous servirons des données procurées par Yahoo finance et nous nous baserons sur une période allant de janvier 2012 jusqu'à décembre 2023
Nous utiliserons la méthode des log-rendements afin de rendre plus interprétable et stabiliser la variance temporelle
L'analyse sera faite sur le language R.
Nous ferons usage de différents modèles de tests comme l'ARIMA, le test ARCH ou encore le Test ADF pour déterminer la présence de racine unitaire.

## Conclusion

Mon analyse résultera sur une non-stationnarité des deux indices boursiers, ainsi qu'une absence d'effet ARCH.
Ensuite l'optimisation via les critères d'informations démontrera un modèle ARIMA (0,0,0) pour les deux indices, prouvant l'absence de composante autorégressive ou de moyenne mobile
Enfin le test de Ljung-Box concluera une indépendance des résidus, affirmant la nature des rendements historiques en bruit blanc. 

Ces conclusions confirmeront l'hypothèse d'efficience des marchés au sens faible (FAMA, 1965), toute l'information publique historique est contenu dans le prix du cours de ces deux indices boursiers. La prévision des rendements futurs de ces deux indices se limitent donc à leurs moyennes historiques.
