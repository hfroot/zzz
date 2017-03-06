import numpy as np
import matplotlib.pyplot as plt
import csv
import pandas as pd
from matplotlib import style
from numpy import genfromtxt
style.use("ggplot")
from sklearn import svm


#import data from csv file
my_data = pd.read_csv('temp_data_belen.csv', sep=',', header=None)
temp_values = my_data.values
new_temp_mean = np.mean(temp_values)
new_temp_max = np.max(temp_values)
print new_temp_mean
print new_temp_max
new_score = [new_temp_mean, new_temp_max]
print new_score

X = np.array([[24.5, 25.5],
             [24.3,25.7],
             [23.9, 24.5],
             [23,24],
             [20.6, 21.3],
             [18.6, 19.2],
              [17,18],
             [16.6, 17.3],
             [16.2, 16.9]])
y = [1,1,1,0,0,0,2,2,2]
#y = np.genfromtxt('train.csv', delimiter=',')
#print y

clf = svm.SVC(kernel='linear', C = 1.0)


clf.fit(X,y)

#predicting values (1 is high, 0 is normal, 2 is low)

#print(clf.predict([25,25.76]))
#print(clf.predict([18.3,19.76]))
#print(clf.predict([23.6, 24.2]))
#print(clf.predict([17, 18]))
print(clf.predict(new_score))



#plot
w = clf.coef_[0]
#w2 = clf.coef_[2]
print(w)

a = -w[0] / w[1]
#b = -w2[2] / w2[0]

xx = np.linspace(20,26)
#xx2 = np.linspace(16, 20)
yy = a * xx - clf.intercept_[0] / w[1]
#yy2 = b * xx2 - clf.intercept_[2] / w2[0]

h0 = plt.plot(xx, yy, 'k-', label="non weighted div")
#h1 = plt.plot(xx2, yy2, 'k-', label="non weighted div")

plt.scatter(X[:, 0], X[:, 1], c = y)
plt.legend()
plt.show()