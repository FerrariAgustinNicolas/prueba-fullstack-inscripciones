export type EstatusAlumno =
  | 'activo'
  | 'baja_empresa'
  | 'baja_programa'
  | 'inscrito'
  | 'suspendido'
  | 'reingreso'
  | 'egresado';

export const ESTATUS_ALUMNO: EstatusAlumno[] = [
  'activo',
  'baja_empresa',
  'baja_programa',
  'inscrito',
  'suspendido',
  'reingreso',
  'egresado',
];