import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AlumnosListado } from './alumnos-listado/alumnos-listado';
import { CambioEstatus } from './cambio-estatus/cambio-estatus';

@NgModule({
  declarations: [AlumnosListado, CambioEstatus],
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  exports: [AlumnosListado, CambioEstatus],
})
export class AlumnosModule {}
