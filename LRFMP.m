date=load('date.mat');
date=date.InvoiceDate;

%d1=date(2);
%d2=date(23);

%caldays(between(d1,d2,'days'))
a= load('data1.mat');
data=a.OnlineRetail1;

data(:,1)=[];
data(1,:)=[];
    
%% davoodi

aaa=load('customerid.mat');
customerid=aaa.aaa;



customerid=union(data(:,1),data(:,1));
%customer= find(data(:,1)>1,1, 'first');
customerid(isnan(customerid))=[];

Ncustomerid=numel(customerid);
now='01/12/2010 08:26';
for i=1:1000
[index1,nub1]=find(data(:,1)==customerid(i),1,'first');
[index2,nub2]=find(data(:,1)==customerid(i),1,'last');

[indexf,nubf]=find(data(:,1)==customerid(i));
R(i)=caldays(between(now,date(index2),'days'));
f(i)=numel(indexf);
m(i)=sum(data(indexf,2));
L(i)=caldays(between(date(index1),date(index2),'days'));
p(i)=max(data(indexf,2));
end

load('lrfmp.mat');
XR=histogram(X(1,:)); xlabel('R')
XL=histogram(X(2,:)); xlabel('F')
XM=histogram(X(3,:)); xlabel('M')
XL=histogram(X(4,:)); xlabel('L')
XP=histogram(X(5,:)); xlabel('P')

