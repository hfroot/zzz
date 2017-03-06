from sklearn import svm
import numpy as np
def svm_temp(input):
    
    new_temp_mean = input["temp_mean"]
    new_temp_max = input["temp_max"]
    
    new_score = [new_temp_mean, new_temp_max]

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
    

    clf = svm.SVC(kernel='linear', C = 1.0)


    clf.fit(X,y)

    #predicting values (1 is high, 0 is normal, 2 is low)

    #print(clf.predict([25,25.76]))
    #print(clf.predict([18.3,19.76]))
    #print(clf.predict([23.6, 24.2]))
    #print(clf.predict([17, 18]))
    return clf.predict(new_score)
    