#!/bin/bash

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
 
# Copyright (C) 2022 Lovis Rentsch <root@lovirent.eu>

# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
 
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

#  0. You just DO WHAT THE FUCK YOU WANT TO.


#shellcolorcodes von stackoverflow
RCol='\e[1m'    # Text Reset

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';


#wo die tododatei liegt
todo=~/todo

list() {

    #list variable
    out=""

    #inhalt der tododatei
    cont=$(cat $todo)

    #zeile, in der die Schleife beim Auslesen ist
    zeile=$(wc -l $todo | head -c 1)+1

    #Schleife, durch alle  Zeilen der TODO Datei (Mit Abfrage, wie viele Zeilen es sind)
    for ((i = 1 ; i < $zeile ; i++)); do

        #entfernen der Dringlichkeitszahl
        rmurg=$(head -$i $todo | tail +$i | cut -c3-)

        #wenn "unwichtig, dann gelb"
        if [[ $(head -$i $todo | tail +$i | head -c 1) == 1 ]]
        then
            out="$out \n $i ${BYel}$rmurg${BWhi}"

        #wenn mittel, dann rot
        else if [[ $(head -$i $todo | tail +$i | head -c 1) == 2 ]]
        then
            out="$out \n $i ${BRed}$rmurg${BWhi}"

        #wenn wichtig, dann Lila
        else if [[ $(head -$i $todo | tail +$i | head -c 1) == 3 ]]
        then
            out="$out \n $i ${BPur}$rmurg${BWhi}"

        #wenn undefiniert, dann weiß und nicht "beschnitten"
        else
            out="$out \n $i ${BWhi}$(head -$i $todo | tail +$i)${BWhi}"
        fi fi fi
    done

    #Inhalt der Listvariable ausgeben
    echo -e "${BWhi}$out \n"
}

#inhalt der allgemeinen Hilfe
help_genreal() {
    echo -e "   todo.sh [${Gre}flag${Whi}] [${Cya}argument${Whi}]"
    echo -e "       ${BGre}-a${Gre} / add / --add ${Cya}      Priorität${Whi},${Cya} TODO"
    echo -e "       ${BGre}-d${Gre} / delete / --delete${Cya} Zeilennummer"
    echo -e "       ${BGre}-l${Gre} / list / --list"
    echo -e "   ${BPur}todo.sh help [${BGre}flag${BPur}]"
    echo -e "   ${Red}todo.sh help ${Gre} init${Whi}"
}

hilfe() {
    case "$#" in
        #wenn kein Hilfsargument gegeben ist
        0)
            help_genreal
            ;;

        1)
        #verschiedene Hilfsargumente
        case "$1" in
            -d | --delete | delete)
                echo -e "   todo.sh ${BGre}-d${Gre} / delete / --delete ${Whi}[${Cya}Zeilennummer${Whi}]"
                ;;

            -a | --add | add)
                echo -e "   todo.sh ${BGre}-a${Gre} / add / --add ${Whi}[${Cya}Dringlichkeit (1; 2; 3), TODO (keine Leerzeichen)${Whi}]"
                ;;

            init)
                echo -e "  \n Es wird empfohlen den 'init' Befehl zu nutzen, wenn das Programm zum ersten Mal benutzt wird."
                ;;

            -l | --list | list)
                echo "help list"
                ;;
            *)
            #wenn ein ungültiges Hilfsagrument gegeben ist
                help_genreal
                ;;

        esac
        ;;
    esac
}

#erstmaliges benutzen
init() {
    #datei erstellen
    touch $todo

    #Beispielinhalt
    echo "1 Erstelle deine ersten TODOs" >> $todo
    echo "3 todo.sh -h" >> $todo
}

case "$#" in
    #wenn kein Argument gegeben ist, verweise zu "Hilfe"
    0)
        hilfe
        list
        ;;

    #es sind 4 Argumente möglich
    1 | 2 | 3 | 4)
        case "$1" in
            #add/Hinzufügen eines Punktes
            -a | --add | add)
                #wenn keine ausreichenden Argumente gegeben sind, verweise auf die Hilfe
                #wenn ein weiterer Parameter gegeben ist, verweise auf die "add hilfe"
                if [[ $2 == "" || $3 == "" || $4 != "" || $2 > 3 ]]
                then
                    hilfe "add"
                else
                    #setze die gegebenen Parameter (Dringlichkeit, TODO) in die gegebene TODO Datei
                    echo "$2 $3" >> $todo
                    list
                fi
                ;;

            -h | --help | help)

                #wenn keine Spezifizierung vorgenommen, verweise auf die allgemeine Hilfe
                if [[ $2 == "" ]]
                then
                    hilfe
                else
                    #sonst die Hilfe zum gegeben Thema
                    hilfe "$2"
                fi
                ;;

            -l | --list | list)
                #list Funktion
                list
                ;;

            -d | --delete | delete)
                #wenn keine zu löschende Zeile gegeben ist, verweise auf die Hilfe
                if [[ $2 == "" ]]
                then
                    hilfe "delete"
                else
                    #sonst frage nach Bestätigung
                    read -p "Sicher? y/N "
                    
                    #wenn Ja, dann lösche
                    if [[ $REPLY =~ ^[Yy]$ ]]
                    then
                        #(Formatierung)
                        a="$2d"
                        #lösche die gegebene Zeile
                        sed -i "$a" $todo
                        #und sende eine Löschbestätigung in Form einer aktualisierten Aufzählung der TODOs
                        list
                    else if [[ $REPLY =~ ^[Nn]$ ]]
                    #wenn nein
                    then
                        #dann abbrechen
                        echo -e "${Pur}Abgebrochen"
                    else if [[ $REPLY == "" ]]
                    #wenn nichts gegeben ist
                    then
                        # dann breche auch ab
                        echo -e "${Pur}Abgebrochen"
                    fi fi fi
                fi
                ;;

            --init | init)
                init
                list
                ;;

            *)
                #falsche Parameter führen zur allgemeinen Hilfestellung
                hilfe
                exit 1
                ;;

        esac
        ;;
esac
