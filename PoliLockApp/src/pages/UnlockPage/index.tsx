import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonButton,
  useIonModal,
} from "@ionic/react";
import { SubmitHandler, FieldValues } from "react-hook-form";
import PasswordForm from "../../components/PasswordForm";
import { lockOpen } from "ionicons/icons";

import UnlockedModal from "./UnlockedModal";
import BlockedModal from "./BlockedModal";
import { useMqtt } from "../../contexts/MqttContext";
import VerifyPasswordForm from "./VerifyPasswordForm";
import { useEffect } from "react";

const UnlockPage: React.FC = () => {
  const { client } = useMqtt();

  const [presentUnlockedModal, dismissUnlockedMOdal] = useIonModal(
    UnlockedModal,
    {
      onDismiss: () => dismissUnlockedMOdal(),
    }
  );

  const [presentBlockedModal, dismissBlockedModal] = useIonModal(BlockedModal, {
    onDismiss: () => dismissBlockedModal(),
  });

  useEffect(() => {
    client?.on("message", (message) => {
      console.log("received message");
      console.log(message);
    });
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Destrancar Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Destrancar Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <VerifyPasswordForm />
      </IonContent>
    </IonPage>
  );
};

export default UnlockPage;
