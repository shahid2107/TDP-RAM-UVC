// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1377, EBLK  * I1372, U  I719);
void  hsG_0__0 (struct dummyq_struct * I1377, EBLK  * I1372, U  I719)
{
    U  I1640;
    U  I1641;
    U  I1642;
    struct futq * I1643;
    struct dummyq_struct * pQ = I1377;
    I1640 = ((U )vcs_clocks) + I719;
    I1642 = I1640 & ((1 << fHashTableSize) - 1);
    I1372->I764 = (EBLK  *)(-1);
    I1372->I765 = I1640;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1372);
    }
    if (I1640 < (U )vcs_clocks) {
        I1641 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1372, I1641 + 1, I1640);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I719 == 1)) {
        I1372->I767 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I764 = I1372;
        peblkFutQ1Tail = I1372;
    }
    else if ((I1643 = pQ->I1280[I1642].I787)) {
        I1372->I767 = (struct eblk *)I1643->I785;
        I1643->I785->I764 = (RP )I1372;
        I1643->I785 = (RmaEblk  *)I1372;
    }
    else {
        sched_hsopt(pQ, I1372, I1640);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
