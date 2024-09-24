class Organismo {
  PVector posicao;
  PVector velocidade;
  float[] dna;
  float vida;    // Indica a aptidão (quanto mais saúde, melhor)
  float velocidadeMax;
  float percepcao; // Distância máxima para detectar recursos
  float tamanho;
  int sexo;
  int tempoNascimento;
  
  Organismo(PVector posicao, float[] dna) {
    this.posicao = posicao.copy();
    this.dna = dna;
    this.vida = 250;
    
    // Fenótipo derivado do genótipo (DNA)
    this.velocidadeMax = map(dna[0], 0, 1, 2, 10);
    this.percepcao = map(dna[1], 0, 1, 50, 200);
    this.tamanho = map(dna[2], 0, 1, 4, 12);
    this.velocidade = PVector.random2D();
    this.sexo = int(random(0,2));
    this.tempoNascimento = 30;
  }
  
  void atualiza() {
    // Movimento simples
    posicao.add(velocidade);
    // Consume energia ao se mover
    vida -= velocidadeMax/10.0;
    
    // Limites da tela
    if (posicao.x > width) posicao.x = 0;
    if (posicao.x < 0) posicao.x = width;
    if (posicao.y > height) posicao.y = 0;
    if (posicao.y < 0) posicao.y = height;
    if (tempoNascimento > 0) {
      tempoNascimento--;
    }
  }
  
  void procuraComida() {
    PVector maisProximo = null;
    float dist = Float.MAX_VALUE;
    
    for (PVector r : comida) {
      float d = PVector.dist(posicao, r);
      if (d < dist && d < percepcao) {
        dist = d;
        maisProximo = r;
      }
    }
    
    if (maisProximo != null) {
      PVector desejado = PVector.sub(maisProximo, posicao);
      desejado.setMag(velocidadeMax);
      
      PVector direcao = PVector.sub(desejado, velocidade);
      velocidade.add(direcao);
      
      // Se reach o recurso, consome-o
      if (dist < tamanho) {
        vida += 20;
        comida.remove(maisProximo);
      }
    }
  }
  
    
  void mostrarNascimento() {
    if (tempoNascimento > 0) {
      noFill();
      stroke(255, 0, 0);  // Cor vermelha para indicar nascimento
      strokeWeight(3);
      ellipse(posicao.x, posicao.y, tamanho + 20, tamanho + 20);
      strokeWeight(1);    // Reseta o stroke para o padrão
    }
  }
  
  Organismo procuraParceiro(){
    float dist = Float.MAX_VALUE;
    Organismo parceiro = null;
    
    for (Organismo r : populacao) {
      float d = PVector.dist(posicao, r.posicao);
      if (d < dist && d < 20 && r.sexo != sexo) {
        dist = d;
        parceiro = r;
      }
    }
    
    return parceiro;
  }
  
  /*
  Organismo reproduzir(Organismo parceiro) {
      float chanceBase = 0.05; 
      int tamanhoPopulacaoAtual = populacao.size(); 
      float chanceReproducao = map(tamanhoPopulacaoAtual, 0, 500, chanceBase, 0.00005); 
  
      // Assegura que a chance nunca será menor que 0.00005 (0.005%)
      chanceReproducao = constrain(chanceReproducao, 0.00005, chanceBase);
  
      // Verifica se ocorre a reprodução com base na chance calculada
      if (random(1) < chanceReproducao && vida > 50 && parceiro.vida > 50) {
          float[] novoDna = new float[3];
  
          for (int i = 0; i < 3; i++) {
              if (int(random(0, 2)) == 1) novoDna[i] = dna[i];
              else novoDna[i] = parceiro.dna[i];
          }
  
          // Adiciona mutação no DNA do filho
          for (int k = 0; k < novoDna.length; k++) {
              if (random(1) < 0.001) novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
          }
  
          vida -= 10; // Reduz a vida do organismo após a reprodução
          return new Organismo(posicao, novoDna); // Retorna o novo organismo
      } else {
          return null; // Não houve reprodução
      }
  }
  */
  
  Organismo reproduzir(Organismo parceiro) {
    if (random(1) < 0.009 && vida > 50 && parceiro.vida > 50) {
      float[] novoDna = new float[3];
      
      for(int i = 0; i < 3; i++){
        if(int(random(0,2)) == 1) novoDna[i] = dna[i];
          else novoDna[i] = parceiro.dna[i];
      }
      
      for(int k = 0; k < novoDna.length; k++)
        if(random(1) < 0.001) novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
      
      vida-=10;
      return new Organismo(posicao, novoDna);
    } else {
      return null;
    }
  }
  
  boolean morreu() {
    return vida <= 0;
  }
  
  void mostra() {
      stroke(0);
      colorMode(HSB, 360, 100, 100);
      

      if (sexo == 0) { 
          fill(cor(map(velocidadeMax, 2, 5, 180, 270)));
      } else { 
          fill(cor(map(velocidadeMax, 2, 5, 60, 0)));  
      }
      
      ellipse(posicao.x, posicao.y, tamanho, tamanho);
      colorMode(RGB, 255, 255, 255);
  }

  color cor(float valor) {
      valor = constrain(valor, 0, 360); 
      return color(valor, 100, 100); 
  }

}
