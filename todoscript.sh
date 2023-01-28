#!/bin/bash

# The EUPL License (EUPL)

# Copyright (c) 2023 Lovis Rentsch 
# Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the ''Licence'');
# You may not use this work except in compliance with the Licence.
# You may obtain a copy of the Licence at:

# <https://eupl.eu/1.2/en>

# Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an ''AS IS'' basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Licence for the specific language governing permissions and limitations under the Licence.

#colorcodes from stackoverflow
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


#points to the todofile
todo=~/.todo


aufz() {
        # identifyer for formating
        if [[ $2 == "e" ]]
        then
            #remove ugency indicator from output
            rmurg=$(head -$1 $todo | tail +$1 | cut -c3-)

            #yellow for low urgency
            if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 1 ]]
            then
                out="$out${BYel}$rmurg${Whi}"

            #red for meduim urgency
            else if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 2 ]]
            then
                out="$out${BRed}$rmurg${Whi}"

            #purple for high urgency
            else if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 3 ]]
            then
                out="$out${BPur}$rmurg${Whi}"

            #if no urgency is defined, output todo in white (and don't remove the first character)
            else
                out="$out${BWhi}$(head -$1 $todo | tail +$1)${Whi}"
            fi fi fi
            echo -e "${BWhi}$out"
        else
            #remove ugency indicator from output
            rmurg=$(head -$1 $todo | tail +$1 | cut -c3-)

            #yellow for low urgency
            if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 1 ]]
            then
                out="$out \n $1 ${BYel}$rmurg${BWhi}"

            #red for meduim urgency
            else if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 2 ]]
            then
                out="$out \n $1 ${BRed}$rmurg${BWhi}"

            #purple for high urgency
            else if [[ $(head -$1 $todo | tail +$1 | head -c 1) == 3 ]]
            then
                out="$out \n $1 ${BPur}$rmurg${BWhi}"

            #if no urgency is defined, output todo in white (and don't remove the first character)
            else
                out="$out \n $1 ${BWhi}$(head -$1 $todo | tail +$1)${BWhi}"
            fi fi fi
        fi
}

list() {

    #list variable
    out=""

    #content of the todo file
    cont=$(cat $todo)

    #current line of the output
    zeile=$(cat $todo | wc -l)+1

    #loop that goes through all the lines that are present in the todo file
    for ((i = 1 ; i < $zeile ; i++)); do
        aufz "$i"
    done

    #echo the output generated in "aufz()"
    echo -e "${BWhi}$out \n"
}

#general help
help_genreal() {
    echo -e "   todo.sh [${Gre}flag${Whi}] [${Cya}argument${Whi}]"
    echo -e "       ${BGre}-a / a${Gre} / add / --add ${Cya}      priority${Whi},${Cya} TODO"
    echo -e "       ${BGre}-d / d${Gre} / delete / --delete${Cya} line number"
    echo -e "       ${BGre}-l / l${Gre} / list / --list"
    echo -e "   ${BPur}todo.sh help [${BGre}flag${BPur}]"
    echo -e "   ${Red}todo.sh help ${Gre} init${Whi}"
}

hilfe() {
    case "$#" in
        #if no further argument is given call general help
        0)
            help_genreal
            ;;

        1)
        #different help menus
        case "$1" in
            -d | --delete | delete | d)
                echo -e "   todo.sh ${BGre}-d / d${Gre} / delete / --delete ${Whi}[${Cya}line number${Whi}]"
                ;;

            -a | --add | add | a)
              echo -e "   todo.sh ${BGre}-a / a${Gre} / add / --add ${Whi}[${Cya}priority (1; 2; 3), TODO (spaces just in quotation marks)${Whi}]"
                ;;

            init)
                echo -e "  \n if you run the script for the first time, it is advised to run the 'init' option"
                ;;

            -l | --list | list | l)
                echo -e "   todo.sh ${BGre}- / l${Gre} / list / --list ${Whi}[${Cya}no argument or a line number to output${Whi}]"
                ;;
            *)
            #if an invalid help argument is given
                help_genreal
                ;;

        esac
        ;;
    esac
}

init() {
    #create the todo file
    touch $todo

    #fill it with placeholder content
    echo "1 create your first TODOs" >> $todo
    echo "3 todo.sh -h" >> $todo
}

case "$#" in
    #if no arguments are passed list the todos and hive the general help
    0)
        hilfe
        list
        ;;

    1 | 2 | 3 | 4)
        case "$1" in

            -a | --add | a | add)
                #if too little or too many or wrong arguments are passed output the help text
                if [[ $2 == "" || $3 == "" || $4 != "" || $2 > 3 ]]
                then
                    hilfe "add"
                else
                    #save the urgency
                    echo "$2 $3" >> $todo
                    list
                fi
                ;;

            -h | h | --help | help)

                #if no specific help is askedgive the general help
                if [[ $2 == "" ]]
                then
                    hilfe
                else
                    #else call the help function with the given parameter
                    hilfe "$2"
                fi
                ;;

            -l | l | --list | list)
                #check the length of the document
                za=$(wc -l $todo | head -c 1)+1

                #list all if no arguments are given
                if [[ $2 == "" ]]
                then
                    list
                else
                    #if a line number is given and it is within the document length
                    if [[ $2 < $za ]]
                    then

                        #then list it
                        aufz "$2" "e"
                    else

                        #else call the help function for "list"
                        hilfe "list"
                    fi
                fi
                ;;

            d | -d | --delete | delete)

                #if no line is given give the help
                if [[ $2 == "" ]]
                then
                    hilfe "delete"
                else
                
                    #if a line number is given and it is within the document length
                    za=$(cat $todo | wc -l)+1
                    if (( $2 < $za ))
                    then

                        #list that line
                        z=$(aufz "$2" "e")
                        echo -e "Are you sure that you want to delete '$z'?"

                        #ask confirmation
                        read -p "[y/N] "

                            #if yes, delete that line
                            if [[ $REPLY =~ ^[Yy]$ ]]
                            then
                                #(format)
                                a="$2d"
                                #delete the line
                                sed -i "$a" $todo
                                #list TODOs (without the deleted one)
                                list
                            else if [[ $REPLY =~ ^[Nn]$ ]]
                            #if no
                            then
                                #exit
                                echo -e "${Pur}stopped${RCol}"
                            else if [[ $REPLY == "" ]]
                            #if nothing is awnsered
                            then
                                #exit
                                echo -e "${Pur}stopped${RCol}"
                            fi fi fi
                    
                    #if the line you want to delete doesn't exist, call the help function
                    else
                        hilfe "delete"
                    fi
                fi
                ;;

            --init | init)
                init
                list
                ;;

            *)
                #wrong options call the help function
                hilfe
                exit 1
                ;;

        esac
        ;;
esac
