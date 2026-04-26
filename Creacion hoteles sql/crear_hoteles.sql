CREATE TABLE Ciudades (
    id_ciudad VARCHAR2(3) PRIMARY KEY, 
    nombre_ciudad VARCHAR2(30) NOT NULL
);


CREATE TABLE Hoteles (
    id_hotel VARCHAR2(6) PRIMARY KEY,
    nombre_hotel VARCHAR2(100) NOT NULL, 
    direccion VARCHAR2(100) NOT NULL, 
    telefono VARCHAR2(15) NOT NULL, 
    descripcion VARCHAR2(500),
    id_ciudad VARCHAR2(3),
    CONSTRAINT fk_ciudad FOREIGN KEY (id_ciudad) 
        REFERENCES Ciudades(id_ciudad)
);


CREATE TABLE Tipo_habitaciones(
    id_tipo NUMBER PRIMARY KEY,
    nombre_tipo VARCHAR2(50),
    costo_alta NUMBER NOT NULL CHECK (costo_alta > 1000 AND costo_alta < 10000),
    costo_baja NUMBER NOT NULL CHECK (costo_baja > 500 AND costo_baja < 1000),
    dimensiones NUMBER NOT NULL,
    tipo_vista VARCHAR2(30) NOT NULL, 
    cantidad_camas NUMBER NOT NULL,
    id_hotel VARCHAR2(6),
    CONSTRAINT fk_tipo_hotel FOREIGN KEY (id_hotel) 
        REFERENCES Hoteles(id_hotel)
);


CREATE TABLE Habitaciones (
    numero_habitacion NUMBER,
    id_hotel VARCHAR2(6),
    id_tipo NUMBER,
    estado BOOLEAN NOT NULL,
    PRIMARY KEY (id_hotel, numero_habitacion),
    CONSTRAINT fk_habitacion_hotel FOREIGN KEY (id_hotel) 
        REFERENCES Hoteles(id_hotel),
    CONSTRAINT fk_habitacion_tipo FOREIGN KEY (id_tipo) 
        REFERENCES Tipo_habitaciones(id_tipo)
);


CREATE TABLE Comodidades (
    id_comodidad NUMBER PRIMARY KEY,
    nombre_comodidad VARCHAR2(20)
);

CREATE TABLE Tipo_habitacion_comodidad(
    id_comodidad NUMBER,
    id_tipo NUMBER,
    PRIMARY KEY (id_comodidad, id_tipo),
    CONSTRAINT fk_thc_comodidad FOREIGN KEY (id_comodidad) 
        REFERENCES Comodidades(id_comodidad),
    CONSTRAINT fk_thc_tipo FOREIGN KEY (id_tipo) 
        REFERENCES Tipo_habitaciones(id_tipo)
);


CREATE TABLE Usuarios (
    id_usuario VARCHAR2(6) PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    apellidos VARCHAR2(30) NOT NULL,
    correo VARCHAR2(50) NOT NULL, 
    telefono VARCHAR2(15) NOT NULL
);

CREATE TABLE Clientes (
    id_usuario VARCHAR2(6) PRIMARY KEY, 
    documento NUMBER,
    CONSTRAINT fk_cliente_usuario FOREIGN KEY (id_usuario) 
        REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Administradores (
    id_usuario VARCHAR2(6) PRIMARY KEY, 
    CONSTRAINT fk_admin_usuario FOREIGN KEY (id_usuario) 
        REFERENCES Usuarios(id_usuario)
);


CREATE TABLE Reservas (
    id_reserva VARCHAR2(6) PRIMARY KEY, 
    id_cliente VARCHAR2(6), 
    id_tipo NUMBER NOT NULL, 
    fecha_entrada DATE NOT NULL, 
    fecha_salida DATE NOT NULL, 
    adultos NUMBER CHECK (adultos > 0), 
    ninos NUMBER CHECK (ninos >= 0), 
    precio_total NUMBER CHECK (precio_total > 0), 
    estado VARCHAR2(15) CHECK (estado IN ('ACTIVA','CANCELADA','FINALIZADA')), 
    numero_noches NUMBER NOT NULL CHECK (numero_noches > 0), 
    temporada VARCHAR2(4) CHECK (temporada IN ('ALTA','BAJA')),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) 
        REFERENCES Clientes(id_usuario),
    CONSTRAINT fk_reserva_tipo FOREIGN KEY (id_tipo)
        REFERENCES Tipo_habitaciones(id_tipo)
);


CREATE TABLE Servicios (
    id_servicio VARCHAR2(6) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL, 
    descripcion VARCHAR2(60), 
    tipo_costo VARCHAR2(10) CHECK (tipo_costo IN ('CONSUMO','FIJO')),
    aplica_por VARCHAR2(10) CHECK (aplica_por IN ('RESERVA','NOCHE','PERSONA')),
    precio NUMBER NOT NULL CHECK (precio >= 0)
);

CREATE TABLE Reserva_servicios (
    id_reserva VARCHAR2(6), 
    id_servicio VARCHAR2(6), 
    cantidad NUMBER NOT NULL CHECK (cantidad >= 1), 
    PRIMARY KEY (id_reserva, id_servicio),
    CONSTRAINT fk_rs_reserva FOREIGN KEY (id_reserva) 
        REFERENCES Reservas(id_reserva),
    CONSTRAINT fk_rs_servicio FOREIGN KEY (id_servicio) 
        REFERENCES Servicios(id_servicio)
);

CREATE TABLE Tipo_habitaciones_servicios (
    id_tipo NUMBER, 
    id_servicio VARCHAR2(6), 
    sobrecosto NUMBER NOT NULL CHECK (sobrecosto >= 0), 
    habilitado NUMBER CHECK (habilitado IN (0,1)),
    PRIMARY KEY (id_tipo, id_servicio),
    CONSTRAINT fk_ths_tipo FOREIGN KEY (id_tipo) 
        REFERENCES Tipo_habitaciones(id_tipo),
    CONSTRAINT fk_ths_servicio FOREIGN KEY (id_servicio) 
        REFERENCES Servicios(id_servicio)
);


CREATE TABLE Camas (
    id_cama NUMBER PRIMARY KEY, 
    tipo_cama VARCHAR2(20) NOT NULL
);

CREATE TABLE Tipo_habitaciones_camas (
    id_tipo NUMBER, 
    id_cama NUMBER,
    PRIMARY KEY (id_tipo, id_cama),
    CONSTRAINT fk_thcama_tipo FOREIGN KEY (id_tipo) 
        REFERENCES Tipo_habitaciones(id_tipo),
    CONSTRAINT fk_thcama_cama FOREIGN KEY (id_cama) 
        REFERENCES Camas(id_cama)
);