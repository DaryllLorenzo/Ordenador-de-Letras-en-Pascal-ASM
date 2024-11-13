program ejercicio(input, output , stderr);
{$asmmode intel}

const
  MAX_LONGITUD = 100;
type
  TArregloChar = array[1..MAX_LONGITUD] of AnsiChar;

var
  arreglo: TArregloChar;
  i: Integer;
  arreglo2 : TArregloChar;
  arreglo3 : TArregloChar;
  
  
begin
  writeln('Ingresa una frase: ');
  readln(arreglo);
	writeln;

  
  asm

    push ebp
    mov ebp, esp

    // Comienzo aqui
    lea esi , [arreglo]
	mov edx , 0
	mov ecx , 0
	mov ebx , 0
	mov edi , 0 // booleano de la ñ
	
    @ciclo1:
    mov ax, [esi + edx]

	cmp al , 163  // u con tilde
	je @tilde3
	
	cmp al , 164 // ñ minuscula
	je @laLinda1
	
	cmp al , 165 // Ñ 
	je @laLinda2
	
	cmp al , 162  // o con tilde
	je @tilde2
	
	cmp al , 130 // e con tilde
	je @tilde1
	
	cmp al , 160 // a con tilde
	je @tilde4
	
	cmp al , 161 // i con tilde
	je @tilde5
	
	cmp al , 181 // a mayuscula con tilde
	je @tilde4
	
	cmp al , 144 // e mayuscula con tilde
	je @tilde1
	
	cmp al, 214 // i mayuscula con tilde
	je @tilde5
	
	cmp al, 224 // o mayuscula con tilde
	je @tilde2
	
	cmp al, 223 // u mayuscula con tilde
	je @tilde3
	
	//181 a mayusculas
	//144 e mayus 
	//214 i mayus 
	//224 o mayus 
	//223 u mayus 
	
	cmp al , 32
	je @espacio
	
    cmp al , 'A' // si es menor esta por debajo de 65 no es letra no vale la pena analizar
    jl @terminar

    cmp al , 91 // simbolo de 91 osea si esta por debajo serian todas las mayusculas
    jl @Mayvalida1

    cmp al , 'a'
    jl @terminar

    cmp al , 123 // simbolo de 123 osea si esta por debajo serian todas las minusculas
    jl @valida1

	
	
	jmp @terminar
	
	@laLinda1: // la eñe
	inc edi // como un boolean de que hay eñe
	mov al , 'n'
	jmp @valida1
	
	@laLinda2:
	inc edi
	mov al , 'n'
	jmp @valida1
	
	
	@espacio:
	inc edx
	inc ebx // para tener cuenta de la cantidad de espacios que hay 
	mov al , [esi + edx]
	cmp al, 0
	jne @ciclo1
	jmp @parte2
	
    //Manejar las tildes y ñ que tengo en el teclado
    @tilde1:
    mov al, 101 //e
    jmp @valida1
	
	@tilde2:
    mov al, 111 //o
    jmp @valida1
	
	@tilde3:
	mov al, 117 //u
	jmp @valida1
	
	@tilde4:
	mov al, 97 // a
	jmp @valida1
	
	@tilde5:
	mov al, 105 // i
	jmp @valida1
	
	
	
	@Mayvalida1:
	add al , 32
	
	
    @valida1: // DEsde aqui es donde se incrementa edx y se regresa al ciclo
    push ax
	inc ecx
    inc edx
    mov al , [esi + edx]
	cmp al, 0
	jne @ciclo1

// Segunda parte guardar en el arreglo
    @parte2:
	cmp ecx , 1 // comprueba que es una sola letra
	je @solo1letra
	mov esi , 0
	sub edx , ebx	// quitandole la cantidad de espacios
	mov ebx , ecx // cantidad de elementos en la pila
    mov ecx , edx
    lea esi , [arreglo2]
    mov edx, 0

    @asignar:

    pop ax
    mov [esi + edx], al
    inc edx
    loop @asignar

///// BURBUJA
mov eax, edi
push eax // almaceno el booleano para saber si hay ñ o no 
	
dec ebx // le quitamos 1 parte del metodo burbuja
mov ecx , ebx

@bucle_exterior:
mov edx, 0
mov edi, 0

@bucle_interior:
mov al, byte ptr [esi + edx]
cmp al, byte ptr [esi + edx + 1]
jbe @salto

movzx ebx, byte ptr [esi + edx + 1]
mov [esi + edx], bl
mov [esi + edx + 1], al
mov edi, 1
@salto:
inc edx
cmp edx, ecx
jl @bucle_interior

cmp edi, 1
jne @comprobarLinda 

dec ecx
jnz @bucle_exterior
	
	
	@comprobarLinda:
	pop bx // sacar el boolean 1 true 0 false
	
	mov ecx , ebx 
	 
	mov edx , 0
	lea esi, [arreglo2]
	cmp bx , 1
	je @remplazar 
	cmp bx , 0 
	jg @remplazar
	
	jmp @bucle3
	
	@remplazar:
	mov al, byte ptr [esi + edx]
	cmp al, 'n'
	jne @noEsN
	
	cmp al , [esi + edx + 1]
	je @noEsN
	mov bl, 164
	mov [esi + edx], bl
	jmp @LOL
	@noEsN:
	inc edx
	jmp @remplazar
	
	@LOL:
	 
	mov [esi + edx],bl
	dec edx
	loop @LOL
	
	
	// Parte 3 sobrescribir arreglo sin los duplicados
@bucle3:
 lea esi, [arreglo2]       // Cargar la dirección base del arreglo original en esi
  lea edi , [arreglo3]
  mov ebx, 0              // Índice para recorrer el arreglo original
  mov ecx, 0              // Contador de elementos únicos
  mov edx, 0              // Índice para contar iteraciones

@bucle:
  mov al, [esi]             
  cmp al, 0                 
  je @terminar

  cmp al, byte [esp]        
  je @elemento_duplicado   
  
  push eax
  mov [edi], al
  
  inc edi
  inc esi
  jmp @bucle

@elemento_duplicado:
  inc esi
  jmp @bucle
  
  
  @solo1letra:
  mov ebx , edi 
  cmp edi , 1
  
  lea edi , [arreglo3]
  mov edx, 0
  pop ax
  
  je @convierte1
  mov [edi + edx] , al
	
	jmp @terminar
  
  @convierte1:
  mov bl , 164
  mov [edi + edx] , bl
  
	jmp @terminar
  
	@terminar:
  mov esp, ebp
  pop ebp

  end;
  
  for i := 1 to MAX_LONGITUD do
    Write(arreglo3[i]);
	 
  Readln;
end.
