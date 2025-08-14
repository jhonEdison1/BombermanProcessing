/** 
*
*
* Clase soldado enemigo hereda de Enemigo
* Representa un soldado enemigo en el juego.
* Es un enemigo que se mueve en la cuadrícula y puede ser destruido por una bomba
*/

class SoldadoEnemigo extends Enemigo {
  boolean direccionX = true; // Indica si se mueve en dirección X o Y
  PImage imgLado, imgFrente;
  int frameCounter = 0;
  int frameDelay = 20;

  SoldadoEnemigo(int x_, int y_, int tileSize_, int velocidad_, int resistencia_) {
    super(x_, y_, tileSize_, "SoldadoEnemigoFrente", velocidad_, resistencia_);
    imgFrente = loadImage("Assets/SoldadoEnemigoFrente.png");
    imgLado = loadImage("Assets/SoldadoEnemigoLado.png");
  }

   @Override
    void mover(String[] mapa, int velocidad, boolean direccion) {

        frameCounter++;
        if (frameCounter < frameDelay) return;
        frameCounter = 0;
        
        int[][] dirs = {{1,0},{-1,0},{0,1},{0,-1}}; // derecha, izquierda, abajo, arriba
        // Mezclar el orden de las direcciones
        for (int i = dirs.length - 1; i > 0; i--) {
            int j = int(random(i + 1));
            int[] temp = dirs[i];
            dirs[i] = dirs[j];
            dirs[j] = temp;
        }
        for (int i = 0; i < dirs.length; i++) {
            int nx = x + dirs[i][0] * velocidad;
            int ny = y + dirs[i][1] * velocidad;
            if (nx >= 0 && nx < mapa[0].length() && ny >= 0 && ny < mapa.length) {
            char destino = mapa[ny].charAt(nx);
            if (destino == '_' || destino == 'P') {
                x = nx;
                y = ny;
                direccionX = (dirs[i][0] != 0);
                break;
            }
            }
        }
    // Si no pudo moverse, se queda en su lugar
    }

    @Override
    void dibujar(int px, int py) {
        if (vivo) {
            if (direccionX) {
                image(imgLado, px, py, tileSize, tileSize);
            } else {
                image(imgFrente, px, py, tileSize, tileSize);
            }
        }
    }
}