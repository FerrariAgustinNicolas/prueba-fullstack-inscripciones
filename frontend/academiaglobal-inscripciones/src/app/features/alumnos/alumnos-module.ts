import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AlumnosListado } from './alumnos-listado/alumnos-listado';
import { CambioEstatus } from './cambio-estatus/cambio-estatus';

@NgModule({
  declarations: [AlumnosListado, CambioEstatus],
  imports: [CommonModule],
  exports: [AlumnosListado, CambioEstatus],
})
export class AlumnosModule {}
