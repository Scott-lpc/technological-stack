C The following is a simple example problem, with the coding
C needed for its solution by DVODE.  The problem is from chemical
C kinetics, and consists of the following three rate equations..
C     dy1/dt = -.04*y1 + 1.e4*y2*y3
C     dy2/dt = .04*y1 - 1.e4*y2*y3 - 3.e7*y2**2
C     dy3/dt = 3.e7*y2**2
C on the interval from t = 0.0 to t = 4.e10, with initial conditions
C y1 = 1.0, y2 = y3 = 0.  The problem is stiff.
C
C The following coding solves this problem with DVODE, using MF = 21
C and printing results at t = .4, 4., ..., 4.e10.  It uses
C ITOL = 2 and ATOL much smaller for y2 than y1 or y3 because
C y2 has much smaller values.
C At the end of the run, statistical quantities of interest are
C printed. (See optional output in the full description below.)
C To generate Fortran source code, replace C in column 1 with a blank
C in the coding below.

      EXTERNAL FEX, JEX
      DOUBLE PRECISION ATOL, RPAR, RTOL, RWORK, T, TOUT, Y
      DIMENSION Y(3), ATOL(3), RWORK(67), IWORK(33)
      NEQ = 3
      Y(1) = 1.0D0
      Y(2) = 0.0D0
      Y(3) = 0.0D0
      T = 0.0D0
      TOUT = 0.4D0
      ITOL = 2
      RTOL = 1.D-4
      ATOL(1) = 1.D-8
      ATOL(2) = 1.D-14
      ATOL(3) = 1.D-6
      ITASK = 1
      ISTATE = 1
      IOPT = 0
      LRW = 67
      LIW = 33
      MF = 22
      DO 40 IOUT = 1,12
        CALL DVODE(FEX,NEQ,Y,T,TOUT,ITOL,RTOL,ATOL,ITASK,ISTATE,
     1            IOPT,RWORK,LRW,IWORK,LIW,JEX,MF,RPAR,IPAR)
        WRITE(6,20)T,Y(1),Y(2),Y(3)
  20    FORMAT(' At t =',D12.4,'   y =',3D14.6)
        IF (ISTATE .LT. 0) GO TO 80
  40    TOUT = TOUT*10.
      WRITE(6,60) IWORK(11),IWORK(12),IWORK(13),IWORK(19),
     1            IWORK(20),IWORK(21),IWORK(22)
  60	FORMAT(/' No. steps =',I4,'   No. f-s =',I4,
     1       '   No. J-s =',I4,'   No. LU-s =',I4/
     2       '  No. nonlinear iterations =',I4/
     3       '  No. nonlinear convergence failures =',I4/
     4       '  No. error test failures =',I4/)
      Pause	
      Stop
  80  WRITE(6,90)ISTATE
  90	FORMAT(///' Error halt.. ISTATE =',I3)
      Pause
      STOP
      END

      SUBROUTINE FEX (NEQ, T, Y, YDOT, RPAR, IPAR)
      DOUBLE PRECISION RPAR, T, Y, YDOT
      DIMENSION Y(NEQ), YDOT(NEQ)
      YDOT(1) = -.04D0*Y(1) + 1.D4*Y(2)*Y(3)
      YDOT(3) = 3.D7*Y(2)*Y(2)
      YDOT(2) = -YDOT(1) - YDOT(3)
      RETURN
      END

      SUBROUTINE JEX (NEQ, T, Y, ML, MU, PD, NRPD, RPAR, IPAR)
      DOUBLE PRECISION PD, RPAR, T, Y
      DIMENSION Y(NEQ), PD(NRPD,NEQ)
      PD(1,1) = -.04D0
      PD(1,2) = 1.D4*Y(3)
      PD(1,3) = 1.D4*Y(2)
      PD(2,1) = .04D0
      PD(2,3) = -PD(1,3)
      PD(3,2) = 6.D7*Y(2)
      PD(2,2) = -PD(1,2) - PD(3,2)
      RETURN
      END
