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
import { getMqttTopic } from "../../config";

const UnlockPage: React.FC = () => {
  const { client } = useMqtt();
  const blockedTopic = getMqttTopic("blocked");
  const lockedTopic = getMqttTopic("locked");

  const [presentUnlockedModal, dismissUnlockedMOdal] = useIonModal(
    UnlockedModal,
    {
      onDismiss: () => dismissUnlockedMOdal(),
    }
  );

  const [presentBlockedModal, dismissBlockedModal] = useIonModal(BlockedModal, {
    onDismiss: () => dismissBlockedModal(),
  });

  const handleBlocked = (message: string) => {
    if (message === "blocked") {
      presentBlockedModal();
    }
  };

  const handleLocked = (message: string) => {
    if (message === "unlocked") {
      presentUnlockedModal();
    }
  };

  const handleIncomingMessages = (topic: string, message: any) => {
    console.log("message", message.toString(), "on topic", topic);
    switch (topic) {
      case blockedTopic:
        handleBlocked(message.toString());
        break;
      case lockedTopic:
        handleLocked(message.toString());
        break;
    }
  };

  useEffect(() => {
    client?.on("message", handleIncomingMessages);

    // Clean up function
    return () => {
      client?.removeListener("message", handleIncomingMessages);
    };
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
