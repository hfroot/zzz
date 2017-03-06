import numpy as np
import matplotlib.pyplot as plt
import csv
import pandas as pd
from matplotlib import style
from numpy import genfromtxt
style.use("ggplot")
from sklearn import svm

#import data from csv file
my_data = pd.read_csv('humid_data_belen.csv', sep=',', header=None)
humid_values = my_data.values
new_humid_mean = np.mean(humid_values)
new_humid_max = np.max(humid_values)
print new_humid_mean
print new_humid_max
new_score = [new_humid_mean, new_humid_max]
print new_score

#import data from csv file
#my_data = pd.read_csv('test_data.csv', sep=',', header=None)
#print my_data.values

X = np.array([[40.5, 44.5],
             [41.3,45.7],
             [39, 43.5],
             [39.5,44],
             [38.6, 41.3],
             [38, 41.2],
              [35,38],
             [36, 38.3],
             [35.2, 38.9]])
y = [1,1,1,1,0,0,2,2,2]
#y = np.genfromtxt('train.csv', delimiter=',')
#print y


clf = svm.SVC(kernel='linear', C = 1.0)


clf.fit(X,y)

#predicting a new value of mean 25 and max 25.76
#print(clf.predict([40,44.76]))
#print(clf.predict([38.3, 41.76]))
#print(clf.predict([35.6, 39]))
#print(clf.predict([37, 40]))
print(clf.predict(new_score))



w = clf.coef_[0]
print(w)

a = -w[0] / w[1]

xx = np.linspace(20,26)
yy = a * xx - clf.intercept_[0] / w[1]

