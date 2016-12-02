import os
import sys


sys.path.append("/home/aiddata/Desktop/Github/CausalForest/scikit-learn")
sys.path.insert(0,"/home/aiddata/miniconda2/lib/python2.7/site-packages/")

import pandas as pd
from sklearn import tree
import csv
import numpy as np 
import random

csvpath = str(sys.argv[1])
c_var = str(sys.argv[2])
o_var = str(sys.argv[3])
p_var = str(sys.argv[4])
out_file = str(sys.argv[5])

 
c_var = c_var.split(",")

full_dta = pd.read_csv(csvpath, header=0)



X = full_dta[c_var]
Y = full_dta[o_var]
sample_weight = full_dta[p_var]


X = X._get_numeric_data()

names = X.columns.values 
row_num = X.shape[0]
col_num = X.shape[1]
feature_num_ratio = 0.8
forest_size = 100000
res = [0]*len(Y)
feature_importance = [0]*col_num
 
 
def featureImpCal(tree, feature_importance):
  left = tree.tree_.children_left
  right = tree.tree_.children_right
  features = tree.tree_.feature
  value = tree.tree_.impurity
  for nodeid in range(0,len(left)):
    if features[nodeid] >= 0:
      feature_importance[features[nodeid]] += value[nodeid] - value[left[nodeid]] - value[right[nodeid]]
 		
resultFile = open(out_file,'wb')
wr = csv.writer(resultFile, delimiter=',')
 	
 
for i in range(0,forest_size):
  print("Building Tree ID:")
  print(i)
  res = [0]*len(Y)
  idx = np.random.choice(Y.index.values, int(0.8*row_num), replace=False) 
  model = tree.DecisionTreeRegressor(criterion='ct', splitter='random',max_features = feature_num_ratio,min_samples_leaf = 25, overlap_samples=0.2)
  fitres = model.fit(np.array(X.iloc[idx], dtype=None),np.array(Y.iloc[idx], dtype=None),np.array(sample_weight.iloc[idx], dtype=None))
  pred = model.predict(np.array(X.iloc[idx], dtype=None))
  for j in range(0,len(idx)):
    res[idx[j]] = pred[j]
  wr.writerow(res)

featureImpCal(model, feature_importance)
 
s = feature_importance
idx = sorted(range(len(s)), key=lambda k: s[k],reverse=True)
names[idx]

 
impurity_res = [0]*col_num
for i in range(0,col_num):
 	impurity_res[i] = s[idx[i]]
 
r2 = zip(names[idx],impurity_res)
print(r2)
# 
# 
# 
