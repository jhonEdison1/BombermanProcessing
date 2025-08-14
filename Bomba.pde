class Bomba {
  int x, y; // posición en la cuadrícula
  int tileSize;
  int tiempoExplosion = 60; // frames hasta explotar (1 seg si draw es 60fps)
  int contador = 0;
  boolean explotada = false;
  PImage imgBomba;
  int explosionAnimCounter = 0;
  int explosionAnimMax = 120; // 60 frames ≈ 1 segundo

  Bomba(int x_, int y_, int tileSize_) {
    x = x_;
    y = y_;
    tileSize = tileSize_;
    imgBomba = loadImage("Assets/Bomba.png");
  }

  void actualizar() {
    if (!explotada) {
      contador++;
      if (contador >= tiempoExplosion) {
        explotada = true;
        explosionAnimCounter = explosionAnimMax;
      }
    }
  }

  void dibujar(int px, int py) {
    if (!explotada) {
      image(imgBomba, px, py, tileSize, tileSize);
    }  else if (explosionAnimCounter > 0) {
      //dibujar la animación de explosión
      noStroke();
      dibujarExplosion();
      explosionAnimCounter--;
      noFill();    
    }
  }

  void dibujarExplosion() {
    // Dibuja la explosión (puedes mejorar el efecto)
    int px = x * tileSize;
    int py = y * tileSize;
    fill(255, 0, 0);
    noStroke();
    ellipse(px + tileSize/2, py + tileSize/2, tileSize*1.5, tileSize*1.5);
  }

  boolean estaExplotada() {
    return explotada;
  }
}
