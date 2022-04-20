% Following the guide on https://www.mathworks.com/help/stats/compactclassificationnaivebayes.predict.html
% Using the data from https://github.com/YingtongDou/CARE-GNN
clear
load('Amazon.mat')
% This dataset has 4 sets: homo, net_upu, net_usu, and net_uvu
% In order to combine these sets, we will add them.
%X = transpose(homo)+transpose(net_upu)+transpose(net_usu)+transpose(net_uvu);
X = full(features);
Y = full(label);
rng('shuffle')
cv = cvpartition(Y,'HoldOut',0.30); % Randomly separate the data into 70% training and 30% testing
trainInds = training(cv); % Requires Statistics and Machine Learning Toolbox
testInds = test(cv);

XTrain = X(trainInds,:);
YTrain = Y(trainInds);
XTest = X(testInds,:);
YTest = Y(testInds);

Mdl = fitcnb(XTrain,YTrain) % Train the Naive Bayes
results = predict(Mdl,XTest); % Test

accurate = 0;
total = 0;
fraudAccurate = 0;
fraudTotal = 0;
fraudDetected = 0;
for index = 1:size(results) % I'm sure Matlab has some way to do this more succintly, but this should work
    total = total + 1;
    if YTest(index) == results(index)
        accurate = accurate + 1;
        if YTest(index) == 1
            fraudAccurate = fraudAccurate + 1;
        end
    end
    if YTest(index) == 1
        fraudTotal = fraudTotal + 1;
    end
    if results(index) == 1
        fraudDetected = fraudDetected + 1;
    end
end
total
accurate
accuracy = accurate/total
fraudAccurate
fraudTotal
precision = fraudAccurate/fraudDetected
recall = fraudAccurate/fraudTotal % Average seems to be about 83%
fValue = (2*precision*recall)/(precision+recall)