Copyright>        OpenRadioss
Copyright>        Copyright (C) 1986-2023 Altair Engineering Inc.
Copyright>
Copyright>        This program is free software: you can redistribute it and/or modify
Copyright>        it under the terms of the GNU Affero General Public License as published by
Copyright>        the Free Software Foundation, either version 3 of the License, or
Copyright>        (at your option) any later version.
Copyright>
Copyright>        This program is distributed in the hope that it will be useful,
Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Copyright>        GNU Affero General Public License for more details.
Copyright>
Copyright>        You should have received a copy of the GNU Affero General Public License
Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
Copyright>
Copyright>
Copyright>        Commercial Alternative: Altair Radioss Software
Copyright>
Copyright>        As an alternative to this open-source version, Altair also offers Altair Radioss
Copyright>        software under a commercial license.  Contact Altair to discuss further if the
Copyright>        commercial version may interest you: https://www.altair.com/radioss/.
Chd|====================================================================
Chd|  NBFUNCT                       source/tools/curve/nbfunc.F   
Chd|-- called by -----------
Chd|        LECTUR                        source/starter/lectur.F       
Chd|-- calls ---------------
Chd|        HM_GET_INTV                   source/devtools/hm_reader/hm_get_intv.F
Chd|        HM_OPTION_COUNT               source/devtools/hm_reader/hm_option_count.F
Chd|        HM_OPTION_READ_KEY            source/devtools/hm_reader/hm_option_read_key.F
Chd|        HM_OPTION_START               source/devtools/hm_reader/hm_option_start.F
Chd|        HM_OPTION_READ_MOD            share/modules1/hm_option_read_mod.F
Chd|        SUBMODEL_MOD                  share/modules1/submodel_mod.F 
Chd|====================================================================
      SUBROUTINE NBFUNCT(NFUNCT,NTABLE,NPTS, LSUBMODEL)
C-----------------------------------------------
C   M o d u l e s
C-----------------------------------------------
      USE SUBMODEL_MOD
      USE HM_OPTION_READ_MOD
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
#include      "implicit_f.inc"
C-----------------------------------------------
C   A n a l y s e   M o d u l e
C-----------------------------------------------
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      INTEGER NFUNCT, NTABLE, NPTS
      TYPE(SUBMODEL_DATA), DIMENSION(NSUBMOD), INTENT(IN) :: LSUBMODEL
C-----------------------------------------------
C   C o m m o n   B l o c k s
C-----------------------------------------------
#include      "scr17_c.inc"
#include      "scr03_c.inc"
#include      "units_c.inc"
#include      "warn_c.inc"
#include      "submod_c.inc"
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      INTEGER I,IT,ID,NPARAM,NPT,NFUNCT0,IBID,NTABLE0,NTABLE1,NTABLETOT
C     REAL
      CHARACTER TITR*nchartitle,KEY*ncharfield,MESS*40
      DATA MESS/' FUNCTION COUNTING                      '/
      INTEGER :: IFUN,N1
      LOGICAL :: IS_AVAILABLE
C======================================================================|

!     Get number of functions, and total number of points
      NFUNCT0 = 0
      CALL HM_OPTION_COUNT('/FUNCT', NFUNCT0)
      NPTS = 0
      IF (NFUNCT0 > 0) THEN
         CALL HM_OPTION_START('/FUNCT')
         DO IFUN = 1, NFUNCT0
            CALL HM_OPTION_READ_KEY(LSUBMODEL)
            CALL HM_GET_INTV('numberofpoints', NPT, IS_AVAILABLE, LSUBMODEL)
            NPTS = NPTS + NPT
         ENDDO
      ENDIF

!     Read tables
      NFUNCT = NFUNCT0
      NTABLE = NFUNCT0


      CALL HM_OPTION_COUNT('/TABLE/0', NTABLE0)
      CALL HM_OPTION_COUNT('/TABLE/1', NTABLE1)



      
      IF (NTABLE0 > 0) THEN
       CALL HM_OPTION_START('/TABLE/0')
       DO I = 1, NTABLE0
         CALL HM_OPTION_READ_KEY(LSUBMODEL, 
     .                           OPTION_ID = ID, 
     .                           OPTION_TITR = TITR)
         CALL HM_GET_INTV('ORDER', NPARAM, IS_AVAILABLE, LSUBMODEL) !dimension of table
         IF (NPARAM == 1) THEN
          CALL HM_GET_INTV('N1', N1, IS_AVAILABLE, LSUBMODEL) !size of X
          NPTS = NPTS + N1
          NFUNCT=NFUNCT+1
         ENDIF
       ENDDO
      ENDIF


      IF (NTABLE1 > 0) THEN
       CALL HM_OPTION_START('/TABLE/1')
       DO I = 1, NTABLE1
         CALL HM_OPTION_READ_KEY(LSUBMODEL, 
     .                           OPTION_ID = ID, 
     .                           OPTION_TITR = TITR)
         CALL HM_GET_INTV('ORDER', NPARAM, IS_AVAILABLE, LSUBMODEL) !dimension of table
         IF (NPARAM == 1) THEN
          CALL HM_GET_INTV('curverows', N1, IS_AVAILABLE, LSUBMODEL) !size of X
          NPTS = NPTS + N1
          NFUNCT=NFUNCT+1
         ENDIF
       ENDDO
      ENDIF
      NTABLE=NTABLE+NTABLE1 + NTABLE0 


C
      NPTS=2*NPTS
C
      RETURN
C-------------------------------------
      END
