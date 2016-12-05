clearvars %limpa as variáveis do workspace

%Definição dos pontos
n = inputdlg('Digite o número de pontos','Pontos',1,{'10'});
n = str2double(n); %converte a resposta para double
lim = 20;
p(n,:) = 0;
for i=1:n
    p(i,1) = randi([0 lim]);
    p(i,2) = randi([0 lim]);
end

%pega o número de pontos
[n_pontos,co] = size(p);

%gráfico inicial com os pontos
figure;plot(p(:,1),p(:,2),'x'); axis([0 lim 0 lim]);

%Input dialog com o número de clusters
k = inputdlg('Digite o número de clusters','Clusters',1,{'3'});
k = str2double(k); %converte a resposta para double

%sorteia números distintos no range de 1 ao numero de pontos
c=randperm(n_pontos); 
%pega os k primeiros sorteados
c=c(1:k);

%plota o gráfico com os centros dos clusters circulados
plot(p(:,1),p(:,2),'x',p(c(:),1),p(c(:),2),'ro'); axis([0 lim 0 lim]);

%questdlg('Clique ok para a primeira junção dos clusters');
questdlg('Clique ok para a primeira junção dos clusters',...
    'Confirmação', ...
	'Ok','Ok');

%cria a variável que guarda os clusters
for i=1:k
    clusters(:,:,i) = p(c(i),:);
end

%Selecionar os pontos O que não são centros
count = 0;
for i = 1:n_pontos
    if (c ~= i)
        O(count+1,1:2) = p(i,1:2);
        count=count+1;
    end
end

%calcular a distância euclidiana dos centros até os pontos O
%matriz de dissmilaridade: n_pontos-k X k
for i = 1:(n_pontos - k)
    for j = 1:k
        %distancia = raiz de (Px - Ox)² + (Py - Oy)²
        dis(i,j) = sqrt( (p(c(j),1) - O(i,1))^2 + (p(c(j),2) - O(i,2))^2 );
    end
end

while (1)
    
    %pega o menor valor na matriz de dissimilaridade
    min_dis = min(min(dis));
    if min_dis == 999
        break
    end
    %pega as coordenadas desse valor na matriz
    [min_x,min_y] = find(dis == min_dis);
    %retira o ponto menor o transformando em 999 (nao consegui deletar da
    %matriz, apenas tornar o ponto 0, o que o tornaria o mínimo, então
    %escolhi o valor 999 pra representar um ponto que já foi clusterizado)
    dis(min_x,:) = 999;
    [x,y,z] = size(clusters(:,:,min_y(1)));
    clusters(x+1,1:2,min_y(1)) =  O(min_x(1),1:2);
end

cor = [' ' 'b.' 'g.' 'r.','c.','m.','y.','k.','w.'];

figure;
plot(p(c(:),1),p(c(:),2),'kx','MarkerSize',15,'LineWidth',3);axis([0 lim 0 lim]);
hold on

for i = 1:k
    plot(clusters(:,1,i),clusters(:,2,i),cor(i*2:i*2+1),'MarkerSize',15,'LineWidth',3);
end

hold off








