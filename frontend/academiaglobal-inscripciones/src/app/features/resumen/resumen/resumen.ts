import { Component } from '@angular/core';
import { Observable, map } from 'rxjs';
import { AlumnoService } from '../../../services/alumno.service';

interface ResumenEstatus {
  total: number;
  activos: number;
  bajasEmpresa: number;
  bajasPrograma: number;
  suspendidos: number;
  inscritos: number;
  reingresos: number;
  egresados: number;
}

@Component({
  selector: 'app-resumen',
  standalone: false,
  templateUrl: './resumen.html',
  styleUrl: './resumen.css',
})
export class Resumen {
  resumen$: Observable<ResumenEstatus>;

  constructor(private alumnoService: AlumnoService) {
    this.resumen$ = this.alumnoService.alumnos$.pipe(
      map((alumnos): ResumenEstatus => ({
        total: alumnos.length,
        activos: alumnos.filter((alumno) => alumno.estatusActual === 'activo').length,
        bajasEmpresa: alumnos.filter((alumno) => alumno.estatusActual === 'baja_empresa').length,
        bajasPrograma: alumnos.filter((alumno) => alumno.estatusActual === 'baja_programa').length,
        suspendidos: alumnos.filter((alumno) => alumno.estatusActual === 'suspendido').length,
        inscritos: alumnos.filter((alumno) => alumno.estatusActual === 'inscrito').length,
        reingresos: alumnos.filter((alumno) => alumno.estatusActual === 'reingreso').length,
        egresados: alumnos.filter((alumno) => alumno.estatusActual === 'egresado').length,
      }))
    );
  }
}