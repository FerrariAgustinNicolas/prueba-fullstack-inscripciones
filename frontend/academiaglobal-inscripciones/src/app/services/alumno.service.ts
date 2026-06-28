import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  Alumno,
  EstatusAlumno,
  HistorialEstatus,
  Programa,
} from '../models';
import { ALUMNOS_MOCK, PROGRAMAS_MOCK } from '../data/mock-data';

@Injectable({
  providedIn: 'root',
})
export class AlumnoService {
  private readonly alumnosStorageKey = 'alumnos';
  private readonly programasStorageKey = 'programas';

  private readonly alumnosSubject = new BehaviorSubject<Alumno[]>(
    this.obtenerAlumnosIniciales()
  );

  private readonly programasSubject = new BehaviorSubject<Programa[]>(
    this.obtenerProgramasIniciales()
  );

  alumnos$ = this.alumnosSubject.asObservable();
  programas$ = this.programasSubject.asObservable();

  obtenerAlumnos(): Alumno[] {
    return this.alumnosSubject.value;
  }

  obtenerProgramas(): Programa[] {
    return this.programasSubject.value;
  }

  obtenerAlumnoPorId(alumnoId: number): Alumno | undefined {
    return this.alumnosSubject.value.find((alumno) => alumno.id === alumnoId);
  }

  agregarAlumno(alumno: Omit<Alumno, 'id' | 'estatusActual' | 'historial'>): void {
    const alumnosActuales = this.alumnosSubject.value;
    const nuevoId = this.generarNuevoId(alumnosActuales);

    const nuevoAlumno: Alumno = {
      ...alumno,
      id: nuevoId,
      estatusActual: 'inscrito',
      historial: [
        {
          id: Date.now(),
          alumnoId: nuevoId,
          estatusAnterior: null,
          estatusNuevo: 'inscrito',
          fechaCambio: new Date().toISOString().split('T')[0],
          motivo: 'Registro inicial del alumno',
        },
      ],
    };

    const alumnosActualizados = [...alumnosActuales, nuevoAlumno];
    this.actualizarAlumnos(alumnosActualizados);
  }

  cambiarEstatus(
    alumnoId: number,
    nuevoEstatus: EstatusAlumno,
    motivo: string
  ): { ok: boolean; mensaje: string } {
    const alumnosActuales = this.alumnosSubject.value;
    const alumno = alumnosActuales.find((item) => item.id === alumnoId);

    if (!alumno) {
      return {
        ok: false,
        mensaje: 'No se encontró el alumno seleccionado.',
      };
    }

    if (alumno.estatusActual === nuevoEstatus) {
      return {
        ok: false,
        mensaje: 'El nuevo estatus no puede ser igual al estatus actual.',
      };
    }

    const motivoNormalizado = motivo.trim();

    if (!motivoNormalizado) {
      return {
        ok: false,
        mensaje: 'El motivo del cambio es obligatorio.',
      };
    }

    const nuevoMovimiento: HistorialEstatus = {
      id: Date.now(),
      alumnoId: alumno.id,
      estatusAnterior: alumno.estatusActual,
      estatusNuevo: nuevoEstatus,
      fechaCambio: new Date().toISOString().split('T')[0],
      motivo: motivoNormalizado,
    };

    const alumnosActualizados = alumnosActuales.map((item) => {
      if (item.id !== alumno.id) {
        return item;
      }

      return {
        ...item,
        estatusActual: nuevoEstatus,
        historial: [...item.historial, nuevoMovimiento],
      };
    });

    this.actualizarAlumnos(alumnosActualizados);

    return {
      ok: true,
      mensaje: 'Cambio de estatus registrado correctamente.',
    };
  }

  reiniciarDatos(): void {
    localStorage.removeItem(this.alumnosStorageKey);
    localStorage.removeItem(this.programasStorageKey);

    this.alumnosSubject.next(ALUMNOS_MOCK);
    this.programasSubject.next(PROGRAMAS_MOCK);

    this.guardarEnStorage();
  }

  private actualizarAlumnos(alumnos: Alumno[]): void {
    this.alumnosSubject.next(alumnos);
    this.guardarEnStorage();
  }

  private obtenerAlumnosIniciales(): Alumno[] {
    const alumnosGuardados = localStorage.getItem(this.alumnosStorageKey);

    if (!alumnosGuardados) {
      return ALUMNOS_MOCK;
    }

    return JSON.parse(alumnosGuardados) as Alumno[];
  }

  private obtenerProgramasIniciales(): Programa[] {
    const programasGuardados = localStorage.getItem(this.programasStorageKey);

    if (!programasGuardados) {
      return PROGRAMAS_MOCK;
    }

    return JSON.parse(programasGuardados) as Programa[];
  }

  private guardarEnStorage(): void {
    localStorage.setItem(
      this.alumnosStorageKey,
      JSON.stringify(this.alumnosSubject.value)
    );

    localStorage.setItem(
      this.programasStorageKey,
      JSON.stringify(this.programasSubject.value)
    );
  }

  private generarNuevoId(alumnos: Alumno[]): number {
    if (alumnos.length === 0) {
      return 1;
    }

    return Math.max(...alumnos.map((alumno) => alumno.id)) + 1;
  }
}