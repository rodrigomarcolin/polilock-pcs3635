import { IonContent, IonPage, IonButton } from "@ionic/react";
import Lottie from "react-lottie";
import blockedAnimationData from "./BlockedAnimation.json";

const BlockedModal = ({ onDismiss }: { onDismiss: () => void }) => {
  const blockedAnimationOptions = {
    loop: false,
    autoplay: true,
    animationData: blockedAnimationData,
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
          <h1>O armário foi bloqueado!</h1>

          <Lottie options={blockedAnimationOptions} height={200} width={200} />

          <IonButton onClick={onDismiss} expand="block" color="success">
            Voltar
          </IonButton>
        </div>
      </IonContent>
    </IonPage>
  );
};

export default BlockedModal;
