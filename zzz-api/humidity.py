from sklearn import svm

def svm_humid(humid_mean, humid_max):
    new_humid_mean = humid_mean
    new_humid_max = humid_max

    new_score = [new_humid_mean, new_humid_max]

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



    clf = svm.SVC(kernel='linear', C = 1.0)


    clf.fit(X,y)

    #predicting a new value of mean 25 and max 25.76
    #print(clf.predict([40,44.76]))
    #print(clf.predict([38.3, 41.76]))
    #print(clf.predict([35.6, 39]))
    #print(clf.predict([37, 40]))
    return clf.predict(new_score)

