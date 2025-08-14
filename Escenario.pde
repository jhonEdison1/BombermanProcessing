class Escenario {
  String[] mapa;
  int filas, columnas, tileSize;
  PImage imgAcero, imgLadrillo;

  Escenario(int filas_, int columnas_, int tileSize_, String nombreMapa) {
    filas = filas_;
    columnas = columnas_;
    tileSize = tileSize_;
    mapa = loadStrings(nombreMapa);  
    imgAcero = loadImage("Assets/Acero.png");
    imgLadrillo = loadImage("Assets/Ladrillo.png");
  }

  void dibujar() {
    for (int y = 0; y < filas; y++) {
      for (int x = 0; x < columnas; x++) {
        char c = mapa[y].charAt(x);
        int px = x * tileSize;
        int py = y * tileSize;
        if (c == '#') {
          image(imgAcero, px, py, tileSize, tileSize);
        } else if (c == '.') {
          image(imgLadrillo, px, py, tileSize, tileSize);
        }
        stroke(180);
        noFill();
        rect(px, py, tileSize, tileSize);
      }
    }
  }
}
