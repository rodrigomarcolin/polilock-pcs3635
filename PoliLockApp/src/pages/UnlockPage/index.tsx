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

const UnlockPage: React.FC = () => {
  const [presentUnlockedModal, dismissUnlockedMOdal] = useIonModal(
    UnlockedModal,
    {
      onDismiss: () => dismissUnlockedMOdal(),
    }
  );

  const [presentBlockedModal, dismissBlockedModal] = useIonModal(BlockedModal, {
    onDismiss: () => dismissBlockedModal(),
  });

  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log(data.senha);

    if (data.senha == "1234567890") {
      presentUnlockedModal();
    } else {
      presentBlockedModal();
    }
  };

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

        <PasswordForm
          onSubmit={onSubmit}
          submitBtnText="Destrancar"
          btnIcon={lockOpen}
        />
      </IonContent>
    </IonPage>
  );
};

export default UnlockPage;
