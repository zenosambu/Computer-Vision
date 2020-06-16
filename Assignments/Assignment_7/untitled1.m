lista(1) = 5/100;
lista(2) = 20/100;
lista(3) = 2/100;
lista(4) = 10/100;
lista(5) = 60/100;
words = [1,1,0,1,3; 1,1,1,1,0; 2,1,0,1,0];
idf = log2(1./lista);
size_d = [15,7,12];
tf_idf_w = zeros(3,5);
query = [1,0,1,1,1];
size_q = 4;
tf_idf_q = (query / size_q ) .* log2(1./lista);
som_w = zeros(3,5);
som_q = (query .*  tf_idf_q);
for i = 1 : 3
        tf_idf_w(i,:) = ( words(i,:) / size_d(i) ).* log2(1./lista);
        sim(i) = sum(tf_idf_w(i,:) .* tf_idf_q) / (norm(tf_idf_w(i,:)) * norm(tf_idf_q));
        term_frequencies(i,:) = ( words(i,:) / size_d(i) );
end






