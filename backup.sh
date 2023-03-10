#!/bin/bash

#*************************BACKUP PARA ARCHIVOS DE TERMUX*************************


#-------------------------->INICIO DE FUNCIONES


#-------------->Crear directorio con el nombre del repositorio
crear_dir(){
	
	clear

	cd $HOME; mkdir $name

	if [ "$(echo $?)" == "0" ]; then

		for c1 in {6..1} #6
		do
			echo -e "  \e[31mIMPORTANT:\e[0m En el directorio \e[34m/home\e[0m se ha creado el directorio \e[34m/$name\e[0m. En este se almacenarán sus contraseñas."
			echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
		done

	else
		echo -e "\n"
		for c2 in {5..1} #5
		do
			echo -e "    \e[31mLOADING...\e[0m"; sleep 1
		done
			
		clear

		for c3 in {3..1} #3
		do
			echo -e "  \e[31mERROR:\e[0m Intentelo nuevamente."
			echo -e "\n    \e[33mLOADING...$c3\e[0m"; sleep 1; clear
		done

		menu
	fi
}


#-------------->Crear la copia de seguridad
ruta(){

	clear

	echo -e "
               \e[36;1m[*]\e[0mMenu Ruta\e[36m[*]\e[0m

  \e[36m[1]\e[0m Ingresar la ruta del archivo a guardar
  \e[36m[2]\e[0m Ingresar el mombre del archivo a guardar

  \e[36m[00]\e[0m Salir
		"
	echo -e "  \e[33mIngrese una opción:\e[0m"; read -p "  -> " rute_name

case $rute_name in
	1)
		clear
		echo -e "  \e[33mIngrese la ruta del archivo a guardar:\e[0m "
		read -p "  -> " rute
		clear
		echo -e "   Esta es la ruta que ingreso:"
		echo -e "   \e[34m$rute\e[0m"
		echo -e "\n   \e[33m¿Desea modificar la ruta?: (y/n)\e[0m"
		read -p "   -> " modificar_r

		if [ "$modificar_r" == "y" ]; then
			ruta
		elif [ "$modificar_r" == "n" ]; then
			cd $rute
			pwd_rute=$(pwd | awk -F / '{print $NF}')
			opc_ruta=$pwd_rute
			clear

		else
			ruta
		fi
	;;

	2)
		clear
		echo -e "  \e[31mIMPORTANT:\e[0m Tenga en cuenta que para el uso de busqueda por nombre, su archivo debe de estar en el directorio \e[34m/home\e[0m."
		echo -e "\n  \e[33mDesea continuar: (y/n)\e[0m"
		read -p "  -> " qstn_ruta_name

		clear

		if [ "$qstn_ruta_name" == "y" ]; then
			cd $HOME
		else
			ruta
		fi

		echo -e "  \e[33m¿El archivo a guardar es un directorio?: (y/n)\e[0m"
		read -p "  -> " opc_ruta_name
		clear

		if [ "$opc_ruta_name" == "y" ]; then
			opc_ext="y"
			clear
		elif [ "$opc_ruta_name" == "n" ]; then
			echo -e "  \e[31mIMPORTANT:\e[0m \e[33mIngrese la extensión del archivo sin el punto\e[0m \e[36m(.)\e[0m\e[33mde verificación.\e[0m"
			read -p "  -> " ext
			opc_ext="n"
			clear
		else
			ruta	
		fi

		if [ "$opc_ext" == "y" ]; then
			echo -e "  \e[33mIngrese el nombre del archivo a guardar:\e[0m "
		elif [ "$opc_ext" == "n" ]; then
			echo -e "  \e[33mIngrese el nombre del archivo\e[0m \e[36m$ext\e[0m \e[33ma guardar:\e[0m "
		else
			ruta
		fi

		read -p "  -> " ruta_name
		clear
		echo -e "  Este es el nombre que ingreso:"

		if [ "$opc_ruta_name" == "y" ]; then
			echo -e "  \e[34m$ruta_name\e[0m"
		else
			echo -e "  \e[34m$ruta_name.$ext\e[0m"
		fi

		echo -e "\n  \e[33m¿Desea modificar el nombre?: (y/n)\e[0m"
		read -p "  -> " modificar_n

		if [ "$modificar_n" == "y" ]; then
			ruta
		elif [ "$modificar_n" == "n" ]; then
			opc_ruta=$ruta_name
			clear

		else
			ruta
		fi
	;;

	
	00)

		clear
		exit
	;;


	*)
		clear
		for c1 in {3..1} #3
		do
			echo -e "  \e[31mERROR:\e[0m Opción inválida."
			echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
		done
		ruta
	;;
esac

	for c2 in {5..1} #5
	do
		echo -e "  Haciendo backup de..."
		if [ "$opc_ruta" == "$pwd_rute" ]; then
			echo -e "  \e[34m$opc_ruta\e[0m"
		else
			if [ "$opc_ruta_name" == "y" ]; then
				echo -e "  \e[34m/$opc_ruta\e[0m"
			else
				echo -e "  \e[34m$opc_ruta.$ext\e[0m"
			fi
		fi	
		echo -e "  ...en el repositorio..."
		echo -e "  \e[34m/$name\e[0m\e[33m...$c2\e[0m"; sleep 1; clear
	done


	if [ "$opc_ruta" == "$pwd_rute" ]; then

		restic -r /storage/emulated/0/$name backup $rute
		backup_ruta_rute=$(echo $?)
	else 
		if [ "$opc_ruta" == "$ruta_name" ]; then

			cd $HOME

			if [ "$opc_ruta_name" == "y" ]; then

				dir_name_d=$(find ./$ruta_name -type d)
				ech_dir_name_d=$(echo $?)
				clear

				if [ "$ech_dir_name_d" == "0" ]; then
					cd $dir_name_d
					echo -e "  \e[32mRuta->\e[0m \e[34m$(pwd $dir_name_d)\e[0m"
					echo -e "\n  \e[33m¿Esta es la ruta del directorio a realizar el backup?: (y/n)\e[0m"
					read -p "  -> " p_dir_name_d
				else
					for c3 in {5..1} #5
					do
						echo -e "  \e[31mERROR:\e[0m El nombre de directorio \e[34m/$ruta_name\e[0m no es válido, intentelo nuevamente."
						echo -e "\n    \e[33mLOADING...$c3\e[0m"; sleep 1; clear
					done
					ruta
				fi

				if [ "$p_dir_name_d" == "y" ]; then
					clear
					for c4 in {5..1} #5
					do
						echo -e "\n  Estos son los archivos actuales de su directorio \e[34m/$ruta_name\e[0m."
						echo -e "    \e[33mLOADING...$c4\e[0m"
						echo -e "\n$(ls)"; sleep 1; clear
					done

					pwd_dir_name_d=$(pwd $dir_name_d)
					restic -r /storage/emulated/0/$name backup $pwd_dir_name_d
					backup_ruta_name_d=$(echo $?)
				else
					ruta
				fi
			else
				dir_name_a=$(find . -name $ruta_name.$ext)
				clear

				echo -e "  \e[32mRuta->\e[0m \e[34m$dir_name_a\e[0m"
				echo -e "\n  \e[33m¿Esta es la ruta del archivo a realizar el backup?: (y/n)\e[0m"
				read -p "  -> " p_dir_name_a
				clear

				if [ "$p_dir_name_a" == "y" ]; then
					restic -r /storage/emulated/0/$name backup $dir_name_a
					backup_ruta_name_a=$(echo $?)	
				else
					ruta
				fi
			fi
		fi
	fi


	if [ "$backup_ruta_rute" = "0" -o "$backup_ruta_name_d" == "0" -o "$backup_ruta_name_a" = "0" ]; then

#-------------->Crear directorio para snapshot
#		cd $HOME/$name
#		mkdir snap_$opc_ruta
#		cd snap_$opc_ruta

#-------------->Crear fichero con ruta
#		if [ "$opc_ruta" == "$pwd_rute" ]; then
#			cd $HOME/$name/snap_$opc_ruta
#			touch ruta_$opc_ruta.txt
#			echo $rute > ruta_$opc_ruta.txt
#		else
#			if [ "$opc_ruta_name" == "y" ]; then
#				cd $HOME/$name/snap_$opc_ruta
#				touch ruta_$opc_ruta.txt
#				echo -e $HOME "\e[33m<-\e[0m" $dir_name_d > ruta_$opc_ruta.txt
#			else
#				cd $HOME/$name/snap_$opc_ruta
#				touch ruta_$opc_ruta.txt
#				echo -e $HOME "\e[33m<-\e[0m" $dir_name_a > ruta_$opc_ruta.txt
#			fi
#		fi

		echo -e "\n  \e[32mNOTA:\e[0m Aquí puede evidenciar la cantidad de directorios, ficheros, y de mas archivos que se han guardado en su repositorio. \n"

		for c5 in {4..1} #4
		do
			echo -e "    \e[33mLOADING...\e[0m"; sleep 3
		done

        clear

		for c6 in {3..1} #3
		do	
#			echo -e "\n  \e[32mNOTA:\e[0m En el directorio \e[34m./home/$name/snap_$opc_ruta\e[0m 
#  se ha creado el fichero \e[34mruta_$opc_ruta.txt\e[0m, 
#  en él podrá encontrar la ruta de su snapshot."
			echo -e "\n  \e[32mOK->\e[0m Archivo subido con éxito:"
			echo -e "    \e[33mLOADING...$c6\e[0m"; sleep 1; clear
		done

	else
		echo -e "\n"
		for c7 in {5..1} #5
		do
			echo -e "    \e[31mLOADING...\e[0m"; sleep 1
		done
	
		clear

		for c8 in {3..1} #3
		do
			echo -e "  \e[31mERROR:\e[0m Intentelo nuevamente."
			echo -e "\n    \e[33mLOADING...$c8\e[0m"; sleep 1; clear
		done

		ruta	
	fi
}


#Visualizar las copias de seguridad que hay en el equipo y su ID
snapshots(){

	clear
	echo -e "  \e[33mAcontinuación ingrese su contraseña.\e[0m \n"

	mostrar_snap=$(restic -r /storage/emulated/0/$name snapshots | grep "ID" -A 2 | tail -n 1 | awk '{print $1}')
	backup_snap=$(echo $?)
	clear
	
	cd $HOME/$name
	mkdir snap_$opc_ruta
	cd snap_$opc_ruta

	if [ "$backup_snap" == "0" ]; then
		cd $HOME/$name/snap_$opc_ruta
		touch id_$opc_ruta.txt
		echo $mostrar_snap > id_$opc_ruta.txt

		for c1 in {8..1} #8
		do
			echo -e "\n  \e[32mNOTA:\e[0m En el directorio \e[34m./home/$name/snap_$opc_ruta\e[0m se ha creado el fichero: \e[34mid_$opc_ruta.txt\e[0m, con el cual podrá recuperar su snapshot en caso de ser eliminado.\n"
			echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
		done

	else
		clear
		for c2 in {3..1} #3
		do
			echo -e "  \e[31mERROR:\e[0m Intentelo nuevamente."
			echo -e "\n    \e[33mLOADING...$c2\e[0m"; sleep 1; clear
		done

		snapshots
	fi
}


#------------------->Mensaje de despedida
despedida(){

	clear

	for c1 in {3..1} #3
	do
		echo -e "\n        \e[36mBACKOUP EXITOSO\e[0m"
		echo -e "          \e[33mBYE...$c1\e[0m"; sleep 1.5; clear
	done
}


#-------------------------->FINAL DE FUNCIONES



#----------------------->INICIO DE PROGRAMA

#----------------------->Instalar Storage
clear
termux-setup-storage -y > /dev/null 2>&1

if [ "$(echo $?)" == "0" ]; then
	for c1 in {3..1} #3
	do
		echo -e "  \e[32mOK->\e[0m Ya tiene instalado \e[34mstorage\e[0m."
		echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
	done

else
	for c2 in {8..1} #8
	do
		echo -e "  \e[31mIMPORTANT:\e[0m Se instaló \e[34mstorage\e[0m."
echo -e "\n  Éste le da acceso a termux al almacenamiento interno y externo del equipo. Lo puede observar acontinuación."
echo -e "\n    \e[33mLOADING...$c2\e[0m"; sleep 1; clear
	done
fi

for c3 in {4..1} #4
do
	cd $home
	ls
	echo -e "\n    \e[33mLOADING...$c3\e[0m"; sleep 1; clear
done



#------------------------->Instar Restic

apt install restic > /dev/null 2>&1

if [ "$(echo $?)" == "0" ]; then
	for c4 in {3..1} #3
	do
		echo -e "  \e[32mOK->\e[0m Ya cuenta con la herramienta \e[34mrestic\e[0m."
		echo -e "\n    \e[33mLOADING...$c4\e[0m"; sleep 1; clear
	done

else
	for c5 in {8..1} #8
	do
		echo -e "  \e[31mIMPORTANT:\e[0m Se instaló la herramienta restic."
		echo -e "  Ya que esta es la que permite realizar el backup."
		echo -e "\n  \e[34mapt install restic\e[0m"
		echo -e "\n    \e[33mLOADING...$c5\e[0m"; sleep 1; clear
	done
fi

for c6 in {4..1} #4
do
	echo -e "  \e[36m$(restic version)\e[0m"
	echo -e "\n    \e[33mLOADING...$c6\e[0m"; sleep 1; clear
done

#------------------------->Instar Locate

#apt install mlocate  > /dev/null 2>&1

#if [ "$(echo $?)" == "0" ]; then
#	for c7 in {3..1} #3
#	do
#		echo -e "  \e[32mOK->\e[0m Ya cuenta con la herramienta \e[34mlocate\e[0m."
#		echo -e "\n    \e[33mLOADING...$c7\e[0m"; sleep 1; clear
#	done
#
#else
#	for c8 in {8..1} #8
#	do
#		echo -e "  \e[31mIMPORTANT:\e[0m Se instaló la herramienta locate."
#		echo -e "  Ya que esta es la que permite realizar busqueda de rutas de archivos."
#		echo -e "\n  \e[34mapt install mlocate\e[0m"
#		echo -e "\n    \e[33mLOADING...$c8\e[0m"; sleep 1; clear
#	done
#fi
#
#for c9 in {4..1} #4
#do
#	echo -e "  \e[34m$(locate --v)\e[0m"
#	echo -e "\n    \e[33mLOADING...$c9\e[0m"; sleep 1; clear
#done

#----------------------->Menu de opciones

menu(){
echo -e "
			      \e[36;1m[*]\e[0mMenu\e[36m[*]\e[0m

		     \e[36m[1]\e[0m Crear un repositorio
		     \e[36m[2]\e[0m Ya cuento con un repositorio
		     \e[36m[3]\e[0m Recuperar un snapshot

		     \e[36m[00]\e[0m Salir
"

echo -e "  \e[33mIngrese una opción:\e[0m"; read -p "  -> " opc

case $opc in
	1)
#-------------->Ingresar nombre para el repositorio
		clear
		echo -e "  \e[33mIngrese el nombre del repositorio a crear:\e[0m"
		read -p "  -> " name
		clear

		echo -e "  Este es el nombre que ingreso: \e[36m$name\e[0m"
		echo -e "\n  \e[33m¿Desea modificar el nombre?: (y/n)\e[0m"
		read -p "  -> " modificar_name

		if [ "$modificar_name" == "n" ]; then
			clear
		else
			clear
			menu
		fi


#-------------->Crear directorio con el nombre del repositorio
		crear_dir


#-------------->Aviso de ingreso de clave
		for c1 in {5..1} #5
		do
			echo -e "  \e[31mIMPORTANT:\e[0m A continuación deberá asignar una clave para el repositorio \e[34m/$name\e[0m."                         
			echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
		done


#-------------->Crear repositorio para el backup
		crear_repo=$(restic -r /storage/emulated/0/$name init) 
		backup_name=$(echo $?)
		id_repo=$(echo $crear_repo | grep "created" | awk '{print $4}')

		if [ "$backup_name" == "0" ]; then

#---------------------->Crea un fichero con la contraseña del 
#-----------------------repositorio.
			clear
			cd $HOME/$name
			touch contraseña_$name.txt
			echo $id_repo > contraseña_$name.txt

			for c2 in {3..1} #3
			do
				echo -e "  \e[32mOK->\e[0m Repositorio \e[34m/$name\e[0m creado con éxito."
				echo -e "\n    \e[33mLOADING...$c2\e[0m"; sleep 1; clear
			done

			for c3 in {15..1} #15
			do	
				echo -e "\n  \e[32mNOTA:\e[0m La contraseña de su repositorio se ha guardado en el directorio \e[34m./home/$name\e[0m como \e[34mcontraseña_$name.txt\e[0m."
				echo -e "\n  \e[31mIMPORTANT:\e[0m Tenga en cuenta que es necesario conocer su contraseña para acceder al repositorio. Perder su contraseña significa que sus datos se pierden irremediablemente." 
				echo -e "\n    \e[33mLOADING...$c3\e[0m"; sleep 1; clear
			done
	
		else
			echo -e "\n"
			for c4 in {5..1} #5
			do
				cd $HOME
				$(rm -rf $name)

				echo -e "    \e[31mLOADING...\e[0m"; sleep 1
			done
			
			clear
			
			for c5 in {3..1} #3
			do
				echo -e "  \e[31mERROR:\e[0m Intentelo nuevamente."
				echo -e "\n    \e[33mLOADING...$c5\e[0m"; sleep 1; clear
			done
			menu
		fi

#-------------->Crear la copia de seguridad
		ruta

#Visualizar las copias de seguridad que hay en el equipo y su ID
		snapshots

#------------------->Mensaje de despedida
		despedida
	;;

	
	2)
#-------------->Hacer backup con un repositorio existente
		clear
		echo -e "  \e[33mIngrese el nombre de su reposotorio:\e[0m"
		read -p "  -> " name

		cd $HOME/storage/shared


#-------------->Crear directorio con el nombre del repositorio
		valid_dir=$(find ./$name -type d)
		ech_valid_dir=$(echo $?)
		clear

		if [ "$ech_valid_dir" == "1" ]; then
			crear_dir
		else
			clear
		fi


#-------------->Crear la copia de seguridad
		ruta

#Visualizar las copias de seguridad que hay en el equipo y su ID
		snapshots

#------------------->Mensaje de despedida
		despedida
	;;
	

	3)
#-------------->Recuperar un snapshot
		recuperar(){
				clear
				echo -e "\e[33m¿Cuenta con los siguienetes datos? (y/n):\e[0m

		   \e[36m[*]\e[0m Nombre del repositorio
		   \e[36m[*]\e[0m ID del snapshot
			"

				read -p "  -> " menu_datos

				if [ "$menu_datos" == "y" ]; then
					clear
				elif [ "$menu_datos" == "n" ]; then

					for c1 in {5..1} #5
					do
						clear
						echo -e "  \e[31mIMPORTANT:\e[0m Lo sentimos, sin estos datos no se puede proceder con la recuperación de archivos."
						echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
					done
					menu
				else
					clear
					recuperar
				fi

				datos(){

					clear
			
					echo -e "  \e[36m1)\e[0m Ingrese el nombre del repositorio:"
					read -p "  -> " name
					clear

					echo -e "  \e[36m2)\e[0m Ingrese el ID del snapshoot:"
					read -p "  -> " id_snap
					clear

					echo -e "  Estos son sus datos ingresados:
						✓ Nombre de repositorio: \e[34m/$name\e[0m
						✓ ID de snapshot: \e[34m$id_snap\e[0m"

					echo -e "\n   \e[33m¿Desea modificarlos? (y/n)\e[0m"
					read -p "   -> " modificar

					if [ "$modificar" == "n" ]; then
						clear
					else
						datos
					fi
				}
				datos

		
				for c2 in {4..1} #4
				do
					echo -e "  Recuperando archivos en el repositorio \e[36m/$name\e[0m\e[33m...$c2\e[0m"; sleep 1; clear
				done

				restic -r /storage/emulated/0/$name restore $id_snap --target $HOME/recuperado
				ech_restic=$(echo $?)
				clear
					
				if [ "$ech_restic" == "0" ]; then

					for c3 in {6..1} #6
					do
						echo -e "  \e[32mOK->\e[0m Su archivo \e[34m$id_snap\e[0m se ha recuperado con éxito. Se encuetra en la ruta /home/recuperado/data/data/com.termux/files/home"
						echo -e "\n    \e[33mLOADING...$c3\e[0m"; sleep 1; clear
					done

				else	
					for c4 in {3..1} #3
					do
						echo -e "  \e[31mERROR:\e[0m Intentelo nuevamente."
						echo -e "\n    \e[33mLOADING...$c4\e[0m"; sleep 1; clear
					done
					datos
				fi
		}
		recuperar
	;;


#-------------->Salir
	00)
		clear
		exit
	;;


#-------------->Default
	*)
		clear
		for c1 in {3..1} #3 
		do
			echo -e "  \e[31mERROR:\e[0m Opción inválida."
			echo -e "\n    \e[33mLOADING...$c1\e[0m"; sleep 1; clear
		done
		menu
	;;
esac
}
menu
#----------------------->FINAL DE PROGRAMA
