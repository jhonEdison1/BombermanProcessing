class Personaje {
  int x, y; // posición en la cuadrícula
  int tileSize;
  PImage imgFrente, imgLado;
  boolean mirandoLado = false;
  int vidas = 3;
  void perderVida() {
    if (vidas > 0) {
      vidas--;
    }
  }

  Personaje(int x_, int y_, int tileSize_) {
    x = x_;
    y = y_;
    tileSize = tileSize_;
    imgFrente = loadImage("Assets/PersonajeFrente.png");
    imgLado = loadImage("Assets/PersonajeLado.png");
  }

  void dibujar(int px, int py) {
  if (mirandoLado) {
    image(imgLado, px, py, tileSize, tileSize);
  } else {
    image(imgFrente, px, py, tileSize, tileSize);
  }
}

  void mover(int dx, int dy, String[] mapa) {
    int nx = x + dx;
    int ny = y + dy;
    // Verifica límites y obstáculos
    if (nx >= 0 && nx < mapa[0].length() && ny >= 0 && ny < mapa.length) {
      char destino = mapa[ny].charAt(nx);
      if (destino == '_' || destino == 'P') {
        x = nx;
        y = ny;
        mirandoLado = (dx != 0); // Si se mueve en x, mira de lado
      }
    }
  }
}
