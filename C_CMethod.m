function [tau,tw]=C_CMethod(data,max_d)
% �������������ӳ�ʱ��tau��ʱ�䴰��tw
% data������ʱ������
% max_d�����ʱ���ӳ�
% Smean��Sdeltmean,ScorΪ����ֵ
% tau������õ����ӳ�ʱ��
% tw��ʱ�䴰��
N=length(data);     %ʱ�����еĳ���
Smean=zeros(1,max_d);    %��ʼ������
Sdeltmean=zeros(1,max_d);
Scor=zeros(1,max_d);
sigma=std(data);      %�������еı�׼��
% ����Smean,Sdeltmean,Scor
for t=1:max_d
    S=zeros(4,4);
    Sdelt=zeros(1,4);
    for m=2:5
        for j=1:4
            r=sigma*j/2;
            Xdt=disjoint(data,t);          % ��ʱ������data�ֽ��t�����ཻ��ʱ������
            s=0;
           for tau=1:t
                N_t=floor(N/t);                          % �ֳɵ������г���
                Y=Xdt(:,tau);                            % ÿ��������           
                
                %����C(1,N/t,r,t),�൱�ڵ���Cs1(tau)=correlation_integral1(Y,r)            
                Cs1(tau)=0;
                for ii=1:N_t-1
                    for jj=ii+1:N_t
                        d1=abs(Y(ii)-Y(jj));     % ����״̬�ռ���ÿ����֮��ľ���,ȡ�����
                        if r>d1
                            Cs1(tau)=Cs1(tau)+1;            
                        end
                    end
                end
                Cs1(tau)=2*Cs1(tau)/(N_t*(N_t-1));
              
                Z=reconstitution(Y,m,1);             % ��ռ��ع�
                M=N_t-(m-1); 
                Cs(tau)=correlation_integral(Z,M,r); % ����C(m,N/t,r,t)
                s=s+(Cs(tau)-Cs1(tau)^m);            % ��t������ص�ʱ���������
           end            
           S(m-1,j)=s/tau;            
        end
        Sdelt(m-1)=max(S(m-1,:))-min(S(m-1,:));          % ��������
    end
    Smean(t)=mean(mean(S));                              % ����ƽ��ֵ
    Sdeltmean(t)=mean(Sdelt);                            % ����ƽ��ֵ
    Scor(t)=abs(Smean(t))+Sdeltmean(t);
end
% Ѱ��ʱ���ӳ�tau����Sdeltmean��һ����Сֵ���Ӧ��t
for i=2:length(Sdeltmean)-1
    if Sdeltmean(i)<Sdeltmean(i-1)&Sdeltmean(i)<Sdeltmean(i+1)
        tau=i;
        break;
    end
end
% Ѱ��ʱ�䴰��tw����Scor��Сֵ��Ӧ��t
for i=1:length(Scor)
    if Scor(i)==min(Scor)
        tw=i;
        break;
    end
end
