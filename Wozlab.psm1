#   G e t   p u b l i c   a n d   p r i v a t e   f u n c t i o n   d e f i n i t i o n   f i l e s .  
 $ P u b l i c     =   @ ( G e t - C h i l d I t e m   - P a t h   $ P S S c r i p t R o o t \ P u b l i c \ * . p s 1   - E r r o r A c t i o n   S i l e n t l y C o n t i n u e )  
 $ P r i v a t e   =   @ ( G e t - C h i l d I t e m   - P a t h   $ P S S c r i p t R o o t \ P r i v a t e \ * . p s 1   - E r r o r A c t i o n   S i l e n t l y C o n t i n u e )  
 #   D o t   s o u r c e   t h e   f i l e s  
 f o r e a c h   ( $ i m p o r t   i n   @ ( $ P u b l i c   +   $ P r i v a t e ) )   {  
     t r y   {  
         .   $ i m p o r t . F u l l N a m e  
     }  
     c a t c h   {  
         W r i t e - E r r o r   - M e s s a g e   " F a i l e d   t o   i m p o r t   f u n c t i o n   $ ( $ i m p o r t . F u l l N a m e ) :   $ _ "  
     }  
 }  
  
 E x p o r t - M o d u l e M e m b e r   - F u n c t i o n   $ P u b l i c . B a s e n a m e   - A l i a s   *  
 