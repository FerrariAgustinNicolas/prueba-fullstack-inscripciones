import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CambioEstatus } from './cambio-estatus';

describe('CambioEstatus', () => {
  let component: CambioEstatus;
  let fixture: ComponentFixture<CambioEstatus>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CambioEstatus],
    }).compileComponents();

    fixture = TestBed.createComponent(CambioEstatus);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
