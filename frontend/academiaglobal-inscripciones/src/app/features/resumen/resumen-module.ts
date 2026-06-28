import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Resumen } from './resumen/resumen';

@NgModule({
  declarations: [Resumen],
  imports: [CommonModule],
  exports: [Resumen],
})
export class ResumenModule {}
