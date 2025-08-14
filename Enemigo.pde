/*
 * Clase Enemigo
 * Representa un enemigo en el juego.
 * es una clase abstracta que define la estructura básica de un enemigo.
 * Los enemigos deben implementar los métodos abstractos para su comportamiento específico.
 * @author Jhon Edison Rosero
 * @version 1.0
 */

 abstract class Enemigo {
  int x, y; // posición en la cuadrícula
  int tileSize;
  int velocidad;
  int resistencia;  
  PImage imgEnemigo;
  boolean vivo = true;


  Enemigo(int x_, int y_, int tileSize_, String nombreImagen, int velocidad_, int resistencia_) {
    x = x_;
    y = y_;
    tileSize = tileSize_;
    imgEnemigo = loadImage("Assets/" + nombreImagen + ".png");
    velocidad = velocidad_;
    resistencia = resistencia_;
  }

  abstract void mover(String[] mapa, int velocidad, boolean direccion);

  void dibujar(int px, int py) {
    if (vivo) {
      image(imgEnemigo, px, py, tileSize, tileSize);
    }
  }

  void morir() {
    vivo = false;
  }

  boolean estaVivo() {
    return vivo;
  }

    int getX() {
        return x;
    }

    int getY() {
        return y;
    }

    void setPosicion(int x_, int y_) {
        x = x_;
        y = y_;
    }

    void setTileSize(int tileSize_) {
        tileSize = tileSize_;
    }

    PImage getImagen() {
        return imgEnemigo;
    }

    void setImagen(String nombreImagen) {
        imgEnemigo = loadImage("Assets/" + nombreImagen + ".png");
    }

    void actualizar() {
        // Método para actualizar el estado del enemigo, si es necesario
    }

    void dibujarEnemigo() {
        int px = x * tileSize;
        int py = y * tileSize;
        dibujar(px, py);
    }

    int getVelocidad() {
        return velocidad;
    }
    int getResistencia() {
        return resistencia;
    }
    void setVelocidad(int velocidad_) {
        velocidad = velocidad_;
    }
    void setResistencia(int resistencia_) {
        resistencia = resistencia_;
    }
}