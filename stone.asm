; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
     org 100h					; 程序加载到100h，可用于生成COM
     x    dw 7
     y    dw 7
	 count dw 50000
	 dcount dw 580
     char db 'A'
	 rdul db 1  ;向右下运动


start:
	
	;显示自己的个人信息
	mov ax,0xb800
	mov es,ax
	mov byte[es:(1*80+19)*2],'1'
	;mov byte[es:(13*80+19)*2+1],0x0A
	mov byte[es:(1*80+20)*2],'6'
	;mov byte[es:(13*80+20)*2+1],0x0A
	mov byte[es:(1*80+21)*2],'3'
	;mov byte[es:(13*80+21)*2+1],0x0C
	mov byte[es:(1*80+22)*2],'3'
	;mov byte[es:(13*80+22)*2+1],0x0C
	mov byte[es:(1*80+23)*2],'7'
	;mov byte[es:(13*80+23)*2+1],0x0E
	mov byte[es:(1*80+24)*2],'0'
	;mov byte[es:(13*80+24)*2+1],0x0E
	mov byte[es:(1*80+25)*2],'9'
	;mov byte[es:(13*80+25)*2+1],0x0B
	mov byte[es:(1*80+26)*2],'8'
	;mov byte[es:(13*80+26)*2+1],0x0B
	mov byte[es:(1*80+28)*2],'H'
	mov byte[es:(1*80+29)*2],'Y'
	mov byte[es:(1*80+30)*2],'K'
	
	
	
    mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov ax,0B800h				; 文本窗口显存起始地址
	mov gs,ax					; GS = B800h
	mov byte[rdul],1
    mov byte[char],'A'        
	mov word[x],7
	mov word[y],7
	mov word[count],delay
	mov word[dcount],ddelay
	
	
	 
	
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	mov word[count],delay      ;重新初始化
	mov word[dcount],ddelay    ;重新初始化

      mov al,1          ;如果是1，进入右下运动模块
      cmp al,byte[rdul]
	jz  DnRt
      mov al,2          ;如果是2，进入右上运动模块
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3          ;如果是3，进入左上运动模块
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4          ;如果是4，进入左下运动模块
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	inc word[x]   ;x++
	inc word[y]   ;y++
	mov bx,word[x]  ;将x的值传给bx
	mov ax,25  ;将25传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  dr2ur  ;等于0，说明超过边界，跳转
	mov bx,word[y] ;将y的值传给bx
	mov ax,80  ;将80传给ax
	sub ax,bx ;两者相减，比较结果是否等于0
      jz  dr2dl ;等于0，说明超过边界，跳转
	jmp show ;不超过边界，跳转显示模块
dr2ur:   ;调整x的值以及运动方向
      mov word[x],23
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:  ;调整y的值以及运动方向
      mov word[y],78
      mov byte[rdul],Dn_Lt	
      jmp show

UpRt:
	dec word[x]  ;x--
	inc word[y]  ;y++
	mov bx,word[y]  ;将y的值传给bx
	mov ax,80  ;将80传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  ur2ul  ;等于0，说明超过边界，跳转
	mov bx,word[x]  ;将x的值传给bx
	mov ax,-1  ;将-1传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  ur2dr  ;等于0，说明超过边界，跳转
	jmp show ;不超过边界，跳转显示模块
ur2ul:  ;调整y的值以及运动方向
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:  ;调整x的值以及运动方向
      mov word[x],1
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]  ;x--
	dec word[y]  ;y--
	mov bx,word[x]  ;将x的值传给bx
	mov ax,-1  ;将-1传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  ul2dl  ;等于0，说明超过边界，跳转
	mov bx,word[y]  ;将y的值传给bx
	mov ax,-1  ;将-1传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  ul2ur  ;等于0，说明超过边界，跳转
	jmp show ;不超过边界，跳转显示模块

ul2dl:  ;调整x的值以及运动方向
      mov word[x],1
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:  ;调整y的值以及运动方向
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]  ;x++
	dec word[y]  ;y--
	mov bx,word[y]  ;将y的值传给bx
	mov ax,-1  ;将-1传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  dl2dr  ;等于0，说明超过边界，跳转
	mov bx,word[x]  ;将x的值传给bx
	mov ax,25  ;将25传给ax
	sub ax,bx  ;两者相减，比较结果是否等于0
      jz  dl2ul  ;等于0，说明超过边界，跳转
	jmp show ;不超过边界，跳转显示模块

dl2dr:  ;调整y的值以及运动方向
      mov word[y],1
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:  ;调整x的值以及运动方向
      mov word[x],23
      mov byte[rdul],Up_Lt	
      jmp show
	
show:	
      xor ax,ax                 ; 计算显存地址
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax   ;计算显存偏移地址，传给bx
	mov ah,byte[y]				;  0000：黑底、1111：亮白字（默认值为07h）
	and ah,0Fh
	
	mov al,byte[char]
	sub al,'Z'
	jnz a1
	mov byte[char],'A'
	jmp show1

a1:
	inc byte[char]
	
show1:
	
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bx],ax  		;  显示字符的ASCII码值
	
	add bx,2
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bx],ax
	
	
	jmp loop1
	
end:
    jmp $                   ; 停止画框，无限循环 
		
    

