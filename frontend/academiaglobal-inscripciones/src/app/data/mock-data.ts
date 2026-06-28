import { Alumno, Programa } from '../models';

export const PROGRAMAS_MOCK: Programa[] = [
  { id: 1, nombre: 'Lic. Administración' },
  { id: 2, nombre: 'Lic. Negocios' },
  { id: 3, nombre: 'Lic. Logística' },
  { id: 4, nombre: 'Maestría en Educación' },
  { id: 5, nombre: 'Bachillerato Ejecutivo' },
];

export const ALUMNOS_MOCK: Alumno[] = [
  {
    id: 1001,
    nombre: 'Luis Cruz',
    empresa: 'Soriana',
    programaId: 2,
    programa: 'Lic. Negocios',
    estatusActual: 'activo',
    fechaInscripcion: '2025-02-26',
    historial: [
      {
        id: 1,
        alumnoId: 1001,
        estatusAnterior: 'inscrito',
        estatusNuevo: 'activo',
        fechaCambio: '2026-02-28',
        motivo: 'Inicio regular del programa',
      },
    ],
  },
  {
    id: 1002,
    nombre: 'Andrés Ramírez',
    empresa: 'Coppel',
    programaId: 1,
    programa: 'Lic. Administración',
    estatusActual: 'suspendido',
    fechaInscripcion: '2025-03-10',
    historial: [
      {
        id: 2,
        alumnoId: 1002,
        estatusAnterior: 'activo',
        estatusNuevo: 'suspendido',
        fechaCambio: '2026-06-18',
        motivo: 'Documentación pendiente',
      },
    ],
  },
  {
    id: 1003,
    nombre: 'María López',
    empresa: 'BBVA',
    programaId: 3,
    programa: 'Lic. Logística',
    estatusActual: 'egresado',
    fechaInscripcion: '2024-08-12',
    historial: [
      {
        id: 3,
        alumnoId: 1003,
        estatusAnterior: 'activo',
        estatusNuevo: 'egresado',
        fechaCambio: '2026-05-20',
        motivo: 'Finalización satisfactoria del programa',
      },
    ],
  },
  {
    id: 1004,
    nombre: 'Daniela Gutiérrez',
    empresa: 'Soriana',
    programaId: 3,
    programa: 'Lic. Logística',
    estatusActual: 'reingreso',
    fechaInscripcion: '2025-01-15',
    historial: [
      {
        id: 4,
        alumnoId: 1004,
        estatusAnterior: 'baja_empresa',
        estatusNuevo: 'reingreso',
        fechaCambio: '2026-06-10',
        motivo: 'Reingreso autorizado por coordinación',
      },
    ],
  },
  {
    id: 1005,
    nombre: 'Sofía Hernández',
    empresa: 'Coppel',
    programaId: 4,
    programa: 'Maestría en Educación',
    estatusActual: 'baja_programa',
    fechaInscripcion: '2025-05-03',
    historial: [
      {
        id: 5,
        alumnoId: 1005,
        estatusAnterior: 'activo',
        estatusNuevo: 'baja_programa',
        fechaCambio: '2026-06-08',
        motivo: 'Baja voluntaria solicitada por el alumno',
      },
    ],
  },
];