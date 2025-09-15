<div class="loader"></div>

<style>
  .loader {
    width: 35px;
    aspect-ratio: 1;
    --_c: no-repeat
      radial-gradient(
        farthest-side,
        var(--color-accent-strong) 92%,
        transparent
      );
    background:
      var(--_c) top,
      var(--_c) left,
      var(--_c) right,
      var(--_c) bottom;
    background-size: 8px 8px;
    animation: l7 1s infinite;
  }
  @keyframes l7 {
    to {
      transform: rotate(0.5turn);
    }
  }

  /* .loader {
    width: 20px;
    aspect-ratio: 1;
    --c: no-repeat linear-gradient(#213547 0 0);
    background: 
      var(--c) 0%   50%,
      var(--c) 50%  50%,
      var(--c) 100% 50%;
    background-size: 20% 100%;
    animation: l1 1s infinite linear;
  }

  @keyframes l1 {
    0%  {background-size: 20% 100%,20% 100%,20% 100%}
    33% {background-size: 20% 10% ,20% 100%,20% 100%}
    50% {background-size: 20% 100%,20% 10% ,20% 100%}
    66% {background-size: 20% 100%,20% 100%,20% 10% }
    100%{background-size: 20% 100%,20% 100%,20% 100%}
  } */
</style>
