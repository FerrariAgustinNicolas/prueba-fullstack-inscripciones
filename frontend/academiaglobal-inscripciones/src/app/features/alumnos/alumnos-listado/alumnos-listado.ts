import { Component } from '@angular/core';
import { BehaviorSubject, combineLatest, map, Observable } from 'rxjs';

import { Alumno, EstatusAlumno, ESTATUS_ALUMNO, Programa } from '../../../models';
import { AlumnoService } from '../../../services/alumno.service';

@Component({
  selector: 'app-alumnos-listado',
  standalone: false,
  templateUrl: './alumnos-listado.html',
  styleUrl: './alumnos-listado.css',
})
export class AlumnosListado {
  estatusDisponibles = ESTATUS_ALUMNO;

  filtroEstatus = '';
  filtroPrograma = '';

  private filtroEstatusSubject = new BehaviorSubject<string>('');
  private filtroProgramaSubject = new BehaviorSubject<string>('');

  alumnosFiltrados$: Observable<Alumno[]>;
  programas$: Observable<Programa[]>;

  constructor(private alumnoService: AlumnoService) {
    this.programas$ = this.alumnoService.programas$;

    this.alumnosFiltrados$ = combineLatest([
      this.alumnoService.alumnos$,
      this.filtroEstatusSubject,
      this.filtroProgramaSubject,
    ]).pipe(
      map(([alumnos, filtroEstatus, filtroPrograma]) =>
        alumnos.filter((alumno) => {
          const coincideEstatus =
            !filtroEstatus || alumno.estatusActual === filtroEstatus;

          const coincidePrograma =
            !filtroPrograma || alumno.programaId === Number(filtroPrograma);

          return coincideEstatus && coincidePrograma;
        })
      )
    );
  }

  actualizarFiltroEstatus(estatus: string): void {
    this.filtroEstatus = estatus;
    this.filtroEstatusSubject.next(estatus);
  }

  actualizarFiltroPrograma(programaId: string): void {
    this.filtroPrograma = programaId;
    this.filtroProgramaSubject.next(programaId);
  }

  limpiarFiltros(): void {
    this.filtroEstatus = '';
    this.filtroPrograma = '';

    this.filtroEstatusSubject.next('');
    this.filtroProgramaSubject.next('');
  }

  formatearEstatus(estatus: EstatusAlumno): string {
    const etiquetas: Record<EstatusAlumno, string> = {
      activo: 'Activo',
      baja_empresa: 'Baja empresa',
      baja_programa: 'Baja programa',
      inscrito: 'Inscrito',
      suspendido: 'Suspendido',
      reingreso: 'Reingreso',
      egresado: 'Egresado',
    };

    return etiquetas[estatus];
  }
}