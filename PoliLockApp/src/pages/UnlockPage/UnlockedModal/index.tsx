import { IonContent, IonPage, IonButton } from "@ionic/react";
import Lottie from "react-lottie";
import unlockAnimationData from "./UnlockAnimation.json";

const UnlockedModal = ({ onDismiss }: { onDismiss: () => void }) => {
  const unlockAnimationOptions = {
    loop: false,
    autoplay: true,
    animationData: unlockAnimationData,
    rendererSettings: {
      preserveAspectRatio: "xMidYMid slice",
    },
  };

  return (
    <IonPage>
      <IonContent
        className="ion-padding"
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "100%",
        }}
      >
        <div
          className="wrapper"
          style={{
            textAlign: "center",
            display: "flex",
            flexDirection: "column",
            gap: 64,
          }}
        >
          <h1>Desbloqueado com Sucesso!</h1>

          <Lottie options={unlockAnimationOptions} height={200} width={200} />

          <IonButton onClick={onDismiss} expand="block" color="success">
            Voltar
          </IonButton>
        </div>
      </IonContent>
    </IonPage>
  );
};

export default UnlockedModal;
